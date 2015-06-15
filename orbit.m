function orbit(step)
deg=360;
[az el]=view;
rotvec=0:step:deg;
axis off;
for i=1:length(rotvec)
   view([az+rotvec(i) el+rotvec(i)]);
   drawnow;
   %pause(0.5);
   axis off;
end
