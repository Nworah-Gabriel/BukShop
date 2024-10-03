// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {IERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Ecommerce {

    IERC20 Borderless_Token;
    address Owner;
    
    //event for buying book
    event BookPurchase(address indexed  purchaser, uint indexed amount, uint indexed  price, uint index);
    //event for approving book
    event BookApproval(address indexed  approver, uint indexed amount, uint indexed price);
    //event for publishing book
    event BookPublished(address indexed  approver, uint indexed amount, uint indexed price);
    //event for deleting book
    event BookDelete(address indexed   seller, uint indexed amount, uint indexed price);
    //event for marking purchase as completed
    event Completed(address indexed purchaser, uint indexed amount, uint indexed price, uint index);
    
    struct Book{
        uint id; 
        string name; 
        uint price; 
        string authorName;
        string Category;
        State BookState;
    }

    enum State{
        approved,
        pending,
        disapproved
    }

    Book[] public books;
    Book[] public purchasedBooks;

    constructor(address _ERC20_Contract) {
        Borderless_Token = IERC20(_ERC20_Contract);
        Owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == Owner, "Only Admin can call this function");
        _;
    }

    
    //function for publishing books
    function PublishBook(
        uint _id,
        string memory _name,
        string memory _authorName,
        uint _price,
        string memory _Category
        ) public payable{
          Book memory book = Book({
            id : _id,
            name : _name,
            price : _price,
            authorName : _authorName,
            Category : _Category,
            BookState: State.pending
          });
          books.push(book);
          emit BookPublished(msg.sender, _price, book.id);
    }
    //function for approving books
    function ApproveBook(uint _id) public onlyOwner{
        Book storage book = books[_id];
        require(book.BookState == State.pending || book.BookState == State.disapproved, "Book is already approved");
        book.BookState = State.approved;
        emit BookApproval(msg.sender, book.price, book.id);
    }

    // function for buying books
    function buyBook(uint _amount, uint bookID) public payable returns (bool){
        require(_amount >= books[bookID].price, "Insufficient funds");
        require(books[bookID].BookState == State.approved, "Book is not approved");
        Borderless_Token.approve(address(this), _amount);
        Borderless_Token.transferFrom(msg.sender, address(this), _amount);
        purchasedBooks.push(books[bookID]);
        emit BookPurchase(msg.sender, _amount, books[bookID].price, books[bookID].id);
        return true;
    }
    
    //function for deleting books
    function DeleteBook(uint _id) public onlyOwner {
        require(_id < books.length, "Book ID is invalid");
        books[_id] = books[books.length - 1]; 
        books.pop();
        emit BookDelete(msg.sender, books[_id].price, books[_id].id);
    }

    //function to withdraw all token in the contract
    function Withdraw() public onlyOwner{
        Borderless_Token.transfer(msg.sender, Borderless_Token.balanceOf(address(this)));
        emit Completed(msg.sender, Borderless_Token.balanceOf(address(this)), Borderless_Token.balanceOf(address(this)), Borderless_Token.balanceOf(address(this)));
    }

    function CheckBalance() public view returns (uint){
        return Borderless_Token.balanceOf(msg.sender);
    }

    function CheckBookLength() public view returns (uint){
        return books.length;
    }

}