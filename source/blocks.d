import std.stdio;
import std.digest.sha;
import std.conv;

void Add(T)(ref T[] arr, ref T elem)
{
    arr[arr.length++] = elem;
}

alias Hash = ubyte[32];
Hash GenerateHash(string data)
{
    return sha256Of(data);
}

static const Hash ZERO_HASH = [0];

/*
    Hold all the blocks
*/
class BlockChain
{
    private Block[] blocks;
    private bool isAltered = false;

    void AddBlock(Block block)
    {
        if (block is null)
            return;
        
        Add(blocks, block);
    }

    Block MineNextBlock(Transaction transaction)
    {
        return MineNextBlock([transaction]);
    }

    Block MineNextBlock(Transaction[] transactions)
    {
        if (!IsValid())
        {
            writeln("Error: Blockchain is invalid now.");
            return null;
        }
        
        // Check if this is the genesis block that we are mining
        auto prevHash = blocks.length == 0 ? 
            ZERO_HASH : blocks[blocks.length - 1].GetHash();
        
        string transactionData;
        foreach (transaction; transactions)
        {
            transactionData ~= transaction.GetHash();
        }

        auto compute = to!string(blocks.length) ~ transactionData;
        auto block = new Block(GenerateHash(compute), prevHash, transactions);
        return block;
    }

    void PrintChain()
    {
        int index = 0;
        foreach (block; blocks)
        {
            writeln("Block: ", index++);
            writeln("Transaction:");
            //writeln("Prev hash: ", block.GetPrevHash(), " , Current hash: ", block.GetHash());
            foreach (transaction; block.GetTransactions())
            {
                transaction.PrintData();
            }
        }
    }

    bool IsValid() const
    {
        // No need to check anymore once our blockchain is altered
        return isAltered ?  false : GetValidity();
    }

    private bool GetValidity() const
    {
        for (size_t i = 1; i < blocks.length; ++i)
        {
            if (blocks[i].GetPrevHash() != blocks[i - 1].GetHash())
                return false;
        }
        return true;
    }

    /*
        Test if the block chain still works after altering some data
    */
    void TestAlterChain(size_t id)
    {
        assert(id < blocks.length);
        blocks[id] = new Block(ZERO_HASH, ZERO_HASH, [new Transaction("Fake Data")]);
    }
}

/*
    Each block will contain some transaction
*/
class Block
{
    private Transaction[] transactions;

    private immutable Hash hash;
    private immutable Hash prevHash;

    this(Hash hash, Hash prevHash, Transaction[] transactions)
    {
        this.hash = hash;
        this.prevHash = prevHash;
        this.transactions = transactions;
    }

    const (Transaction[]) GetTransactions() const
    {
        return transactions;
    }

    void AddTransaction(Transaction transaction)
    {
        Add(transactions, transaction);
    }

    Hash GetHash() const
    {
        return hash;
    }

    Hash GetPrevHash() const
    {
        return prevHash;
    }
}

/*
    Each transaction holds some data
*/
class Transaction
{
    private string data;

    this(string data)
    {
        this.data = data;
    }

    const (string) GetString() const
    {
        return data;
    }

    const (string) GetHash() const
    {
        return to!string(GenerateHash(data));
    }

    void PrintData() const
    {
        writeln(data);
    }
}