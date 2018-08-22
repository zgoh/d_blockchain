/*
    Simple block chain proof of concept
*/
import blocks;
import std.stdio;

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

    writeln("Is blockchain still valid: ", chain.IsValid());
    writeln("-------------------- Testing altering blockchain and adding -----------------------");

    // Alter the chain
    chain.TestAlterChain(0);

    // And try adding
    writeln("Adding new blocks here will be invalid, as blockchain is violated");
    auto tx3 = new Transaction("DD");
    block = chain.MineNextBlock(tx3);

    writeln("Block is not added.");
    chain.AddBlock(block);

    chain.PrintChain();
    writeln("Is blockchain still valid: ", chain.IsValid());
}