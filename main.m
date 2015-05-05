
OS_SIZE = 4;                    %
RED=[255, 0, 0];                %Grab the red color
WHT=[255];                      %Dictate white color
image_database;                 %Image database
dbBasePath = '../iris_img_db/'; %Path to original images
dbSavePath = 'imgdb_processed/';%Path to where the osiris has stored photos

extension = [ '_segm.bmp'; ...  %Extensions to stored images
              '_mask.bmp'; ...  %
              '_para.txt';];    %

for fileIndex = 4:1:4%size(hq_img,1)
  fileName = hq_img( fileIndex, : );
  orgName  = strcat( dbBasePath, fileName );
  skelName = strcat( dbSavePath, fileName( 12:end-4 ) );
  fileNames = [ strcat( skelName, extension(1,:) ); ...
                strcat( skelName, extension(2,:) ); ...
                strcat( skelName, extension(3,:) ); ];
  
  imgNoise  = imread( fileNames(1,:) );
  imgSignal = imread( fileNames(2,:) );
  
  [tIris, nIris, sIris, tPupil, tAll] = area( imgNoise, imgSignal );
  [Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:) );
  
%  figure; imshow( tAll   );  title( 'IRIS + PUPIL' );
%  figure; imshow( tPupil );  title( 'PUPIL AREA' );
%  figure; imshow( tIris  );  title( 'IRIS AREA' );
%  figure; imshow( nIris  );  title( 'NOISY IRIS AREA' );
%  figure; imshow( sIris  );  title( 'NOISE FREE IRIS AREA'  );

  Ao = nnz( nIris ) / nnz( tIris   );
  Ac = nnz( sIris   );
  Aa = Ia;
  Ta = It;
  Ap = P_AREA / I_AREA;
  
  clear fileNames skelName orgName fileName imgNoise imgSignal
  clear Ia It I_AREA Pa Pt P_AREA totIris irisNoise irisSignal Pupil Total
end

clear RED extension fileIndex hq_img lq_img OS_SIZE WHT
