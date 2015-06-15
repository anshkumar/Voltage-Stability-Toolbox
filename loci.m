figure('NumberTitle','off','Name','VST - Loci of Eigenvalues');
set(gcf,'defaulttextcolor','black');
set(gcf,'defaultaxesxcolor','black');
set(gcf,'defaultaxesycolor','black');
set(gcf,'defaultaxeszcolor','black');
set(gcf,'defaultsurfaceedgecolor','black');
set(gcf,'Color','w');

plot(real(chleigv(chlm,chln)),imag(chleigv(chlm,chln)),'rx');
xlabel('Real');
ylabel('Imaginary');
