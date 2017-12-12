Using google tesseract and SAS to convert bmp formatted picture of christmas trees to ascii txt

* a very simple example;

INPUT
=====

   https://goo.gl/sUjMMu
   https://www.google.com/search?q=ascii+christmas+tree&tbm=isch&tbo=u&source=univ&sa=X&ved=0ahUKEwjppp2WjoPYAhWBc98KHcwOD8cQsAQILg&biw=1210&bih=704&dpr=1.25#imgrc=th7jHFI968bt

   I used print screen and paint to save the image as a bmp


PROCESS  (see end of message for details on tesseract)
=======================================================

  * after installing tesseract just excute this CLI (command line interface)
  x c:/progra~2/tesseract-ocr/tesseract d:/bmp/treebmp.bmp d:/bmp/treebmp.txt;

   * use utlrulr to get 'hex' split characters;
   %utlrulr
         (
          uinflt =d:/bmp/treebmp.txt.txt,
          uprnlen =100,    /* Linesize for Dump */
          ulrecl  =100,    /* maximum record length */
          urecfm   =f,
          uobs = 10,       /* number of obs to dump */
          uotflt =d:/txt/hexout.txt
         );
   OUTPUT OF HEX RULER

   SCII Flatfile Ruler & Hex
   utlrulr
   d:/bmp/treebmp.txt.txt
   d:/txt/hexout.txt


    --- Record Number ---  1   ---  Record Length ---- 68

   A..VERY..MERRY..CHRISTMAS..AND MY..BEST WISHES..FOR THE NEXT..YEAR..
   1...5....10...15...20...25...30...35...40...45...50...55...60...65..
   40054550044555004454554450044424500445525454450044525442445500544500
   1AA6529AAD5229AA382934D13AA1E40D9AA25340793853AA6F204850E584AA9512AA

   * '..' means split and double space.

   A..VERY..MERRY..CHRISTMAS..AND MY..BEST WISHES..FOR THE NEXT..YEAR..

   data want;
     length wrds $64;
     infile "d:/bmp/treebmp.txt.txt" lrecl=68 recfm=f;
     input;
     _infile_=tranwrd(_infile_,'0A0A'x,'@') ;
     do i=1 to countc(_infile_,'@');
      wrds=scan(_infile_,i,'@');
      lyn=put(wrds,$64. -c);
      put lyn $char64. /;
      output;
     end;
     keep wrds lyn;
     stop;
   run;quit;

OUTPUT IN THE LOG
=================

           A

         VERY

         MERRY

       CHRISTMAS

        AND MY

      BEST WISHES

     FOR THE NEXT

         YEAR



/* T0099610 OCR using SAS/WPS and Tesseract-OCR (state of the art google offering)

  WORKING CODE

      SAS Code to create an BMP image.

      %tesser(device=bmp,type=bmp);

      * Tesseract Converts text inside an image to ascii text;
      * bmp to text;
      x c:/progra~2/tesseract-ocr/tesseract d:/tesser/slide.bmp d:/tesser/slide.txt;



If you have IML interface to R you can use google tesseract. This is the tool
google uses to digitise books.

 OCR using SAS and Tesseract-OCR (state of the art google offering)

Adminstrative information

Where I originally got the tesseract package
https://github.com/UB-Mannheim/tesseract/wiki

There is GUI available and you get a console with both distributions.
I did not install the GUI.

Also located on my google drive(use this before they do a SAS like enhancement)
https://drive.google.com/file/d/0ByX2ii2B0Rq9MmZmVVNjLXpNdkU/view?usp=sharing

Need this to handle PDFs
Get ghostscript here (note ghostscript can combine PDF files and can convert PDF to TIF.
http://www.ghostscript.com/download/gsdnld.html
Really only need one executable.

===============================================

HAVE SIX IMAGE FILES I NEED TO EXTRACT THE TEXT

I have these image files

 png.png
 bmp.bmp
 jpg.jpg
 tiff.tiff
 gif.gif

 pdftif.tiff  (you need to convert the PDF to an Image file)

IMAGE LOOKS LIKE (from proc gslide)

MYSTUDY C304456                               AJAX
DRAFT                                             VER 1.0

                      Ajax Study
                   Dose and Placebo

                         NOTE1
                         NOTE2
                         NOTE3
                         NOTE


PGM: C:\Tut\Tut_GrfTwoWthTtl.sas
OUT: C:\Tut\Tut_GrfTwoWthTtl.pdf - 16AUG16 06:21

================================================

WANT ( All of them converted to text)

MYSTUDY C304456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1
NOTE2
NOTE3
NOTE


PGM: C:\Tut\Tut_GrfTwoWthTtl.sas
OUT: C:\Tut\Tut_GrfTwoWthTtl.pdf - 16AUG16 06:21

SOLUTION

Basically it is one command and two commands for a PDF.

  * conver to text example - bmp to text;

  x c:/progra~2/tesseract-ocr/tesseract d:/tesser/slide.bmp d:/tesser/slide.txt;

 Note teseract-OCR is not purfect?

Create the image files and convert to text using

%macro tesser(device=png300,type=png);

 filename outfile "d:\tesser\&type..&type";
 goptions
    reset=all
    rotate=portrait
    gsfmode = replace
    device  = &device
    gsfname = outfile
    vsize=10in
    hsize=8in
    htext=2 ;
  run;quit;

  proc gslide ;

   title1 j=l h=2 font='Simplex' "MYSTUDY C04456" j=r "AJAX";
   title2 j=l h=2 font='Couier' "DRAFT" j=r "VER 1.0";
   title3 j=l h=2 " ";
   title4 j=c h=3.0 font='Helvetica' "Ajax Study";
   title5 j=c h=3.0 font='Arial' "Dose and Placebo";
   note j=c h=5 "NOTE1";
   note j=c h=5 "NOTE2";
   note j=c h=5 "NOTE3";
   note j=c h=5 "NOTE";
   footnote1 j=l h=2 font='Times Roman' "PGM: C:\Tut\Tut_GrfTwoWthTtl.sas ";
   footnote2 j=l h=2 font='Helvetica'   "OUT: C:\Tut\Tut_GrfTwoWthTtl.pdf - &sysdate &systime";

  run;
  quit;

  goptions reset=all;
  filename outfile clear;
  run;quit;

 ***          *****  *****  *   *  *****
*   *           *    *      *   *    *
    *           *    *       * *     *
  **            *    ****     *      *
 *              *    *       * *     *
*               *    *      *   *    *
*****           *    *****  *   *    *

#! 2aTEXT ;

  * convert to text;
  x c:/progra~2/tesseract-ocr/tesseract d:/tesser/&type..&type d:/tesser/&type..txt;

%mend tesser;


%tesser(device=png300,type=png);
%tesser(device=jpeg300,type=jpg);
%tesser(device=bmp,type=bmp);
%tesser(device=tiff,type=tiff);
%tesser(device=gif,type=gif);

* Here is how to handle a PDF;

Note pdf's often contain embedded fonts so it is better to use another tool to extract the text.
There are many free tools acrobat(even reader?), pdfwriter and pdf2text, boxoft and others in R nd Python.

You can convert the pdf to an image using free goshtscript at http://www.ghostscript.com/download/gsdnld.html.
You really only need  gswin64.exe.

Converting a pdf to a tiff and ectracting the text using tesseract,

x C:\Progra~1\gs\gs9.19\bin\gswin64.exe -dNOPAUSE -dBATCH -sDEVICE=tiffg4 -sOutputFile=d:/tesser/pdftif.tiff d:/tesser/pdf.pdf;
x c:/progra~2/tesseract-ocr/tesseract d:/tesser/pdftif.tiff d:/tesser/pdftif.txt;


TEXT files I created (not perfect and each may be a little different

/*

****   *   *   ***
*   *  **  *  *   *
*   *  * * *  *
****   *  **  * ***
*      *   *  *   *
*      *   *  *   *
*      *   *   ***

#! PNG ;


d:/tesser/png.txt

MYSTU DY CO4456 AJAX
DRAFT VER 1 .0

Ajax Study
Dose and Placebo

NOTE1
NOTEZ
NOTES
NOTE

PGM: C:\| ut\l 961wÂ§ththas

OUT: C:\Tut\Tut_GrF|'wo_VVthTtl.pdf - 16AUG16 06:21

    *  ****    ***
    *  *   *  *   *
    *  *   *  *
    *  ****   * ***
    *  *      *   *
*   *  *      *   *
 ***   *       ***

#! JPG ;


MYSTUDY CO4456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1

NOTEZ

NOTE3

NOTE

PGM: C:\Tut\Tut_GrfTwthhTtl.sas
OUT: C:\Tut\Tut_GrfTwthhTtl.pdf - 16AUG16 06:21
MYSTUDY (304456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1
NOTEZ
NOTES
NOTE

PGM: C:\| ut\l 961wÂ§ththas

OUT: C:\Tut\Tut_GrF|'wo_VVthTtl.pdf - 16AUG16 06:21


****   ****   *****  *****  *****  *****
*   *   *  *  *        *      *    *
*   *   *  *  *        *      *    *
****    *  *  ****     *      *    ****
*       *  *  *        *      *    *
*       *  *  *        *      *    *
*      ****   *        *    *****  *


MYSTUDY CO4456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1

NOTE2

NOTE3

NOTE

PGM: C:\Tut\Tut_GrfTwthhTtl.sas
OUT: C:\Tut\Tut_GrfTwthhTtl.pdf - 16AUG16 06:21

****   *   *  ****
 *  *  ** **  *   *
 *  *  * * *  *   *
 ***   *   *  ****
 *  *  *   *  *
 *  *  *   *  *
****   *   *  *

#! BMP ;

MYSTUDY CO4456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1

NOTEZ

NOTE3
NOTE

PGM: C:\Tut\Tut_GrfTwthhTtl.sas
OUT: C:\Tut\Tut_GrfTwthhTtl.pdf - 16AUG16 06:21

*****  *****  *****  *****
  *      *    *      *
  *      *    *      *
  *      *    ****   ****
  *      *    *      *
  *      *    *      *
  *    *****  *      *

#! TIFF ;

MYSTUDY (304456 AJAX
DRAFT VER 1.0

Ajax Study
Dose and Placebo

NOTE1
NOTEZ
NOTES

PGM: C:\| ut\l 961wÂ§ththas

OUT: C:\Tut\Tut_GrF|'wo_VVthTtl.pdf - 16AUG16 06:21

 ***   *****  *****
*   *    *    *
*        *    *
* ***    *    ****
*   *    *    *
*   *    *    *
 ***   *****  *

#! GIF ;


MYSTU DY CO4456 AJAX
DRAFT VER 1 .0

Ajax Study
Dose and Placebo

NOTE1

NOTE2

NOTE3
NOTE

PGM: C:\Tut\Tut_Gnâ€˜TwthhTt|.sas
OUT: C:\Tut\Tut_Gnâ€˜TwthhTt|.pdf - 16AUG16 06:21
MYSTU DY CO4456 AJAX
DRAFT VER 1 .0

Ajax Study
Dose and Placebo

NOTE1

NOTE2

NOTE3
NOTE

PGM: C:\Tut\Tut_Gnâ€˜TwthhTt|.sas
OUT: C:\Tut\Tut_Gnâ€˜TwthhTt|.pdf - 16AUG16 06:21



