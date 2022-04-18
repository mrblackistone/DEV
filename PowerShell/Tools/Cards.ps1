[Int32]$numDecks = Read-Host "Enter number of decks"
[System.Collections.ArrayList]$baseDeck = @(
    [PSCustomObject]@{
        Name = "Ace"
        Values = @(1,13)
    },
    [PSCustomObject]@{
        Name = "Two"
        Values = @(2)
    },
    [PSCustomObject]@{
        Name = "Three"
        Values = @(3)
    },
    [PSCustomObject]@{
        Name = "Four"
        Values = @(4)
    },
    [PSCustomObject]@{
        Name = "Five"
        Values = @(5)
    },
    [PSCustomObject]@{
        Name = "Six"
        Values = @(6)
    },
    [PSCustomObject]@{
        Name = "Seven"
        Values = @(7)
    },
    [PSCustomObject]@{
        Name = "Eight"
        Values = @(8)
    },
    [PSCustomObject]@{
        Name = "Nine"
        Values = @(9)
    },
    [PSCustomObject]@{
        Name = "Ten"
        Values = @(10)
    },
    [PSCustomObject]@{
        Name = "Jack"
        Values = @(10)
    },
    [PSCustomObject]@{
        Name = "Queen"
        Values = @(10)
    },
    [PSCustomObject]@{
        Name = "King"
        Values = @(10)
    }
)

for ($a = 1; $a -le $numDecks; $a++) {

}

$object1 = [System.Object]::new()
$class1 = [System.Type]::new("1",1)
