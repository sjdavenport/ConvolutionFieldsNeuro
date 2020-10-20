set(0,'defaultAxesFontSize', 12); %This sets the default font size. 


x = 0:489;
TR = 0.735;
x = x*TR;
rng(2)
blocklength = 20;
store_blocks = gen_rand_blocks( blocklength, 490 );

mateA = store_blocks(1,1).mate;
mateB = store_blocks(1,2).mate;

blocksA = ones(1,length(x));
blocksB = ones(1,length(x));

for I = 1:size(mateA,1)
    blocksA((mateA(I,1):(mateA(I,1) + mateA(I,2))) + 1) = -1;
end

for I = 1:size(mateB,1)
    blocksB((mateB(I,1):(mateB(I,1) + mateB(I,2))) + 1) = -1;
end

plot(x, blocksA(1:490))
ylim([-1.2,1.2])


xlabel('Time (s)')
ylabel('Block Height')
title('First Level Block Design')
xlim([x(1),x(end)])

global ncfloc
export_fig([ncfloc, 'Figures/First_level_design/blockdesign.pdf'], '-transparent')

% hold on
% plot(x, blocksB(1:490))


% blocks = 