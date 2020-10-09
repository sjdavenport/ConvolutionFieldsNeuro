x = 0:489;
TR = 0.835;
x = x*TR;
rng(2)
blocklength = 20;
store_blocks = gen_rand_blocks( blocklength, 490 );

mateA = store_blocks(1,1).mate;
mateB = store_blocks(1,2).mate;

blocksA = zeros(1,length(x));
blocksB = zeros(1,length(x));

for I = 1:size(mateA,1)
    blocksA((mateA(I,1):(mateA(I,1) + mateA(I,2))) + 1) = 1;
end

for I = 1:size(mateB,1)
    blocksB((mateB(I,1):(mateB(I,1) + mateB(I,2))) + 1) = 1;
end

plot(x, blocksA(1:490))
ylim([0,1.2])
xlabel('Time (s)')
ylabel('Block Height')
xlim([x(1),x(end)])



% hold on
% plot(x, blocksB(1:490))


% blocks = 