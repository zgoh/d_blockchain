import std.stdio;

void Add(T)(ref T[] arr, ref T elem)
{
    arr[arr.length++] = elem;
}

int GenerateHash()
{
    static int hash = 20;
    return hash++;
}

/*
    Hold all the blocks
*/
class BlockChain
{
    private Block[] blocks;

    void AddBlock(Block block)
    {
        if (block is null)
        {
            writeln("Warning: Adding invalid block");
            return;
        }
        
        Add(blocks, block);
    }

    Block MineNextBlock(Transaction transaction)
    {
        if (!IsValid())
            return null;
        
        // Check if this is the genesis block that we are mining
        auto prevHash = blocks.length == 0 ? 
            0 : blocks[blocks.length - 1].GetHash();
        
        auto block = new Block(GenerateHash(), prevHash, transaction);
        return block;
    }

    void PrintChain()
    {
        foreach (block; blocks)
        {
            writefln("Prev hash: %d, Current hash: %d", block.GetPrevHash(), block.GetHash());
            foreach (transaction; block.GetTransactions())
            {
                transaction.PrintData();
            }
        }
    }

    bool IsValid() const
    {
        for (size_t i = 1; i < blocks.length; ++i)
        {
            if (blocks[i].GetPrevHash() != blocks[i - 1].GetHash())
                return false;
        }
        return true;
    }
}

/*
    Each block will contain some transaction
*/
class Block
{
    private Transaction[] transactions;

    private immutable int hash;
    private immutable int prevHash;

    this(int hash, int prevHash, Transaction transaction)
    {
        this.hash = hash;
        this.prevHash = prevHash;

        AddTransaction(transaction);
    }

    const (Transaction[]) GetTransactions() const
    {
        return transactions;
    }

    void AddTransaction(Transaction transaction)
    {
        Add(transactions, transaction);
    }

    int GetHash() const
    {
        return hash;
    }

    int GetPrevHash() const
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

    void PrintData() const
    {
        writeln(data);
    }
}