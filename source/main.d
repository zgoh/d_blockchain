/*
    Simple block chain proof of concept
*/
import blocks;

void main()
{
    BlockChain chain = new BlockChain();

    Transaction tx = new Transaction("AA");
    auto block = chain.MineNextBlock(tx);
    chain.AddBlock(block);

    tx = new Transaction("BB");
    block = chain.MineNextBlock(tx);
    chain.AddBlock(block);

    chain.PrintChain();
}