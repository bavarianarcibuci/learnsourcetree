%--------------------------------------------------------------
%
%
%
%           %%%    %%%       %%%      %%%%%%%%
%           %%%    %%%      %%%     %%%%%%%%%            
%           %%%    %%%     %%%    %%%%
%           %%%    %%%    %%%    %%%
%           %%%    %%%   %%%    %%%
%           %%%    %%%  %%%    %%%
%           %%%    %%% %%%    %%%
%           %%%    %%%%%%    %%%
%           %%%    %%%%%     %%% 
%           %%%    %%%%       %%%%%%%%%%%%
%           %%%    %%%          %%%%%%%%%   calcMSE.M
%
%
% calculate the mean square error of the image
%
% input:        number of Parameters to use
%
% returnvalue:  MSE
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Yilin Li  
%               21.10.2013 (created)
%
%-----------------------------------------------------------------------------------

function [ MSE ] = calcMSE( ORIGINAL_image, RECONSTRUCTED_image, ORIGINAL_dimensions, ORIGINAL_height, ORIGINAL_width )


%---------------------------------
% calculate MSE
%---------------------------------
fprintf('\n\n-----------------------------------\n- Calculating MSE\n');

MSE = sum( ( ORIGINAL_image( : ) - RECONSTRUCTED_image( : ) ).^2 ) / ( ORIGINAL_dimensions * ORIGINAL_height * ORIGINAL_width );

fprintf('MSE: %d\n', MSE);
fprintf('- Calucalating MSE COMPLETE\n');

return ; % return MSE