video = vision.VideoFileReader('ADVEN_9a_c.mov'); 
v = VideoReader('ADVEN_9a_c.mov');
viewer = vision.DeployableVideoPlayer;
frames = size(read(v));
array = zeros(frames(4),1);
%writer = VideoWriter('ResizedVideo');

 % create the video writer with 1 fps
 writerObj = VideoWriter('myVideo.avi');
 writerObj.FrameRate = 1;
 % set the seconds per image
 %secsPerImage = [5 10 15];
 % open the video writer
 open(writerObj);

%open(writer);
for frame = 1:frames(4)
     A = step(video);  
     viewframe = imresize(A,[480 480]);
     step(viewer, viewframe);   
    writeVideo(writerObj, viewframe);
    %writeVideo(writer,viewframe);
    
end
%release(video);
release(viewer);

disp("The new size of this video is : ");
disp(array);
%size(read(video))
%close(v);
  


