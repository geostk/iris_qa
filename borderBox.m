%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Feature for main.m
%%	This calculates the min bounding box and angle of the pupil and iris
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Date:					XXXX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IAa, ITa, I_AREA, PAa, PTa, P_AREA] = borderBox( imgParameter, org )
  param     =  imgParameter;
  count     =  1;
  minAngle  = -1;
  RE        =  zeros(5,2);
  dM        =  0;
  dm        =  0;
  P_AREA    = -1;
  PW        =  0;
  PH        =  0;
  I_AREA    = -1;
  IW        =  0;
  IH        =  0;
  
  pD        = importdata( param );  %Import osirisdata -> 1 column matrix
  Ph        = pD(1);                %Number of datapoints for pupil
  pB        = zeros(Ph, 3);         %Matrix to hold border coordinates
  Ih        = pD(2);                %Number of datapoints for iris
  iB        = zeros(Ih, 3);         %Matrix to hold border coordinates
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%   Calculate minimum bounding rectangle of pupile
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for I = 3:3:(3*Ph)														%Generate pupil border matrix
    pB(count,:) = [pD(I:I+2)];  
    count = count + 1;
  end
  
  minAngle  = -1;
  pupilHull = convhull(pB(:,1), pB(:,2) );			%Get convex hull
  COOR      = pB( pupilHull, 1:2);							%Grab coordinate values of the 
																								%	points in the convex hull
  
  for I=1:1:size(COOR,1)  											%For all coordinates
    [DX, DY]  = getDelta( COOR, I  );					  %Calculate delta of current edge
    Angle     = atan2d(   DY,   DX );				  	%Calculate vector angle degrees
    [M, W, H] = rotateBox(COOR, Angle, 			...	%Rotate and measure values of 
													COOR( 1, 1:2) );			%	the convex hull
    
    if P_AREA == -1 || P_AREA > M								%If minArea,  update
      minAngle  = Angle;												%
      P_AREA    = M;														%
      PW        = W;														%
      PH        = H;														%
     														% 
      if W > H																	%Set dM and dm
        dM=W; dm=H;															%
      else																			%
        dM=H; dm=W;															%
      end																				%
    end																					%End of 
  end																						%End coordinate loop
  
  %Calculate angled rectangle
  RE(2,:) = [ (cosd(minAngle)*PW),            sind(minAngle)*PW ];
  RE(4,:) = [ RE(1,1) + (sind(minAngle)*PH),  RE(1,2) + (cosd(minAngle)*PH) ];
  RE(3,:) = [ RE(2,1) - RE(4,1),              RE(2,2) + RE(4,2) ];
  RE(4,:) = [ 0       - RE(4,1),              RE(3,2) - RE(2,2) ];
  
  %alpha angle and Theta rotation
  PAa = (1-(dm/dM));
  if RE(2,2) <= 0
    PTa = tand( atan2d( (RE(2,2)/dM), (RE(2,1)/dM) )  );
  else
    PTa = tand( atan2d( ((0-RE(2,2))/dM), ((0-RE(2,1))/dM) ) );
  end
  
  
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%   Calculate minimum bounding rectangle of iris    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Reset values
  minAngle  = -1;
  count     =  1;
  
  %Generate pupil border matrix
  for I = 3*Ph+3:3:(3*Ph)+(3*Ih)
    iB(count,:) = [ pD(I:I+2) ];
    count = count + 1;
  end
  
  %Get convex hull
  irisHull = convhull(iB(:,1), iB(:,2) );
  %Grab coordinate values of the points in the convex hull
  COOR     = iB( irisHull, 1:2);
  for I=1:1:size(COOR,1)
    %Calculate delta of current edge
    [DX, DY]  = getDelta( COOR, I  );
    %Calculate the angle of the vector in degrees
    Angle     = atan2d(   DY,   DX );
    %Rotate and measure values of the convex hull
    [M, W, H] = rotateBox( COOR, Angle );
    
    %If minArea,  update
    if I_AREA == -1 || I_AREA > M
      minAngle = Angle;
      I_AREA  = M;
      IW      = W;
      IH      = H;
      %Set dM and dm
      if W > H
        dM=W; dm=H;
      else
        dM=H; dm=W;
      end
    end
  end
  
  %Calculate angled rectangle
  RE(2,:) = [ (cosd(minAngle)*IW),            sind(minAngle)*IW ];
  RE(4,:) = [ RE(1,1) + (sind(minAngle)*IH),  RE(1,2) + (cosd(minAngle)*IH) ];
  RE(3,:) = [ RE(2,1) - RE(4,1),              RE(2,2) + RE(4,2) ];
  RE(4,:) = [ 0       - RE(4,1),              RE(3,2) - RE(2,2) ];
  
  %alpha angle and Theta rotation
  IAa = (1-(dm/dM));
  if RE(2,2) <= 0
    ITa = tand( atan2d( (RE(2,2)/dM), (RE(2,1)/dM) )  );
  else
    ITa = tand( atan2d( ((0-RE(2,2))/dM), ((0-RE(2,1))/dM) ) );
  end
  
return
  
