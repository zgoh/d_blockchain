/*
    Simple block chain proof of concept
*/
import blocks;

void main()
{
    BlockChain chain = new BlockChain();

    Transaction tx0 = new Transaction("AA");
    auto block = chain.MineNextBlock(tx0);
    chain.AddBlock(block);

    auto tx1 = new Transaction("BB");
    block = chain.MineNextBlock(tx1);
    chain.AddBlock(block);

    auto tx2 = new Transaction("CC");
    auto txs = [tx0, tx1, tx2];
    block = chain.MineNextBlock(txs);
    chain.AddBlock(block);

    chain.PrintChain();
}