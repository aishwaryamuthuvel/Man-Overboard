close all
filename = 'newfile_crop.avi';
hVideoSrc = VideoReader(filename);
NumFrames = hVideoSrc.NumFrames;
%v = VideoWriter('detected_distance');
hVideoOut = vision.VideoPlayer();
imagePoints = [385,470];
skyline = [0 500]; 
Motion = [Vx_a(126:150,1) Vy_a(76:100,1)]; %After trails
i = 1;
p_loc = [50,25];
buoy_loc = [0 0];
R = 6.4 * 10^6;
h = 2.5;
buoy_distance = 0;
buoy_first_frame = false;
%open(v)
while hasFrame(hVideoSrc) 
    % Read in new frame
    img_RGB = readFrame(hVideoSrc);
    img = rgb2gray(im2single(img_RGB));
    imagePoints = imagePoints + Motion(i,:);
    img_p = insertShape(img_RGB,'Rectangle', [(round(imagePoints(1))-50) (round(imagePoints(2))-25) 100 50]);
    ROI = img((round(imagePoints(2))-25):(round(imagePoints(2))+25),(round(imagePoints(1))-50):(round(imagePoints(1))+50));
    ROI_t = imbinarize(ROI,0.7);
    stats = regionprops(ROI_t,'Centroid');
    if size(stats,1)~=0
        if size(stats,1)>1
            d = zeros([size(stats,1),1]);
            for j = 1:size(stats,1)
                d(j,1) = sqrt(sum((stats(j).Centroid - p_loc).^2));
            end
            [~,j] = min(d(:));
            if min(d(:)) < 10
                img_p = insertMarker(img_p,(imagePoints + stats(j).Centroid - [50,25]),'o','color','red','size',5);
                p_loc = stats(j).Centroid;
                buoy_loc = (imagePoints + stats(j).Centroid - [50,25]);
                if buoy_first_frame == false
                    alpha = acosd(R/(R+h));
                    m = (cameraParams.PrincipalPoint(1)-(buoy_loc(1)+274))/(cameraParams.PrincipalPoint(2)-(buoy_loc(2)+64)); 
                    skyline(1) = (500-cameraParams.PrincipalPoint(1)+(m*cameraParams.PrincipalPoint(2)))/m;
                    p1 = cameraParams.IntrinsicMatrix/[skyline 1]; 
                    theta1 = atand(norm(cross(p1,[0 0 1]))/dot(p1,[0 0 1]));
                    p2 = cameraParams.IntrinsicMatrix/([buoy_loc 1]+[274 64 0]); 
                    theta2 = atand(norm(cross(p2,[0 0 1]))/dot(p2,[0 0 1]));
                    beta = theta1 - theta2;
                    gamma = 90 - alpha - beta;
                    buoy_distance = sind(180 - gamma - (180 - asind((R+h)*sind(gamma)/R)))*R/sind(gamma);
                    img_p = insertText(img_p,(buoy_loc + [10 10]),['Distance:' num2str(buoy_distance) 'm'],'BoxColor','white','TextColor','red');
                    buoy_first_frame = true;
                else
                    alpha = alpha + beta;
                    theta1 = theta2;
                    p2 = cameraParams.IntrinsicMatrix/([buoy_loc 1]+[274 64 0]); 
                    theta2 = atand(norm(cross(p2,[0 0 1]))/dot(p2,[0 0 1]));
                    beta = theta1 - theta2;
                    gamma = 90 - alpha - beta;
                    buoy_distance = sind(180 - gamma - (180 - asind((R+h)*sind(gamma)/R)))*R/sind(gamma);
                    img_p = insertText(img_p,(buoy_loc + [10 10]),['Distance:' num2str(buoy_distance) 'm'],'BoxColor','white','TextColor','red');
                end
            end
        else
            d(1,1) = sqrt(sum((stats(1).Centroid - p_loc).^2));
            if d(1,1) < 10
                img_p = insertMarker(img_p,(imagePoints + stats(1).Centroid - [50,25]),'o','color','red','size',5);
                p_loc = stats(1).Centroid;
                buoy_loc = (imagePoints + stats(1).Centroid - [50,25]);
                if buoy_first_frame == false 
                    alpha = acosd(R/(R+h));
                    m = (cameraParams.PrincipalPoint(1)-(buoy_loc(1)+274))/(cameraParams.PrincipalPoint(2)-(buoy_loc(2)+64)); 
                    skyline(1) = (500-cameraParams.PrincipalPoint(1)+(m*cameraParams.PrincipalPoint(2)))/m;
                    p1 = cameraParams.IntrinsicMatrix/[skyline 1]; 
                    theta1 = atand(norm(cross(p1,[0 0 1]))/dot(p1,[0 0 1]));
                    p2 = cameraParams.IntrinsicMatrix/([buoy_loc 1]+[274 64 0]); 
                    theta2 = atand(norm(cross(p2,[0 0 1]))/dot(p2,[0 0 1]));
                    beta = theta2 - theta1;
                    gamma = 90 - alpha - beta;
                    buoy_distance = sind(180 - gamma - (180 - asind((R+h)*sind(gamma)/R)))*R/sind(gamma); 
                    img_p = insertText(img_p,(buoy_loc + [10 10]),['Distance:' num2str(buoy_distance) 'm'],'BoxColor','white','TextColor','red');
                    buoy_first_frame = true;
                else
                    alpha = alpha + beta;
                    theta1 = theta2;
                    p2 = cameraParams.IntrinsicMatrix/([buoy_loc 1]+[274 64 0]); 
                    theta2 = atand(norm(cross(p2,[0 0 1]))/dot(p2,[0 0 1]));
                    beta = theta1 - theta2;
                    gamma = 90 - alpha - beta;
                    buoy_distance = sind(180 - gamma - (180 - asind((R+h)*sind(gamma)/R)))*R/sind(gamma);
                    img_p = insertText(img_p,(buoy_loc + [10 10]),['Distance:' num2str(buoy_distance) 'm'],'BoxColor','white','TextColor','red');
                end
            end
        end
    end
    %writeVideo(v,img_p)
    hVideoOut(img_p);
    if i == 25
        i = 1;
    else
        i = i+1;
    end
end
%close(v)

