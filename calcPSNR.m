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
%           %%%    %%%          %%%%%%%%%   calcPSNR.M
%
%
% calculate the peak signal-noise-ratio of the image
%
% input:        MSE
%
% returnvalue:  PSNR
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Yilin Li  
%               21.10.2013 (created)
%
%-----------------------------------------------------------------------------------

function [ PSNR ] = calcPSNR( MSE )


%---------------------------------
% calculate PSNR
%---------------------------------
fprintf('\n- Calculating PSNR\n');

PSNR = 10 * log10( ( 2^8-1 ) .^ 2 / MSE );

fprintf('PSNR: %f\n', PSNR);
fprintf('- Calcalating PSNR COMPLETE\n-----------------------------------\n\n');

return ; % return success