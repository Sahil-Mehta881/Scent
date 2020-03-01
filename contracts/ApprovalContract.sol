/*
pragma solidity ^0.5.16;

contract ApprovalContract {

	address public sender;
	address payable public receiver;
	// address public approver = 0xD16d5B0FBC562B40F59B1aC59680B316eD310305;

	address public approver = sender;


	function deposit (address payable _receiver) external payable {
		require (msg.value > 0);
		sender = msg.sender;
		receiver = _receiver;
	}

	function viewApprover() external returns (address) {
		return approver;
	}

	function approve() external {
		// require(msg.sender == approver);
		// receiver.transfer(address(this).balance);


		require(msg.sender == approver);
    	receiver.transfer(address(this).balance);
	}

}
*/

pragma solidity ^0.5.16;



contract ApprovalContract {


    /*

	Approval Conditions:
	all buyers/renters agree how much they are paying
	    -- all "equity" adds up to 100%
	seller consents to the transaction (sellerConsent)

    someone sets up an equity share in contract
      -- this is stored here (numBuyers changes to 1 and variables are declared)
    people keep setting up equity shares until totalEquity = 1
      -- when totalEquity = 1, you query for the seller's consent (signature)
      -- once the seller has signed, you query for the buyer's signature
    once both have signed, then you approve the contract, causing the transactions to take place


    All Variables Needed from Frontend (js):

        share of each buyer when added
        the value of the property
        buyers' addresses
        seller's address
        confirmation of seller's signature
        confirmation of each buyer's signature




    Questions:
    How do I implement a contract that stores multiple addresses?
    At what point (and how) do buyers put in money?
    At what point (and how) does money get transferred to seller?
    How do you ensure that the right address is correlated with correct amount of money to transfer?

    */

    // enum and struct are from OpenBazaar github contract code

    enum Status {FUNDED, RELEASED}

    ITokenContract token = ITokenContract(); // from OpenBazaar

    struct Transaction {
        uint256 value;
        uint256 lastModified;
        Status status;
        // TransactionType transactionType;
        uint8 threshold;
        uint32 timeoutHours;
        address buyer;
        address seller;
        address tokenAddress; //address of ERC20 token if applicable
        address moderator;
        uint256 released;
        uint256 noOfReleases; //number of times funds have been released
        mapping(address => bool) isOwner;
        //tracks who has authorized release of funds from escrow
        mapping(bytes32 => bool) voted;
        //tracks who has received funds released from escrow
        mapping(address => bool) beneficiaries;
    }


	address[] buyers;
	address payable public seller;
	// address public approver = 0xD16d5B0FBC562B40F59B1aC59680B316eD310305;

	address public approver = seller;

	int numBuyers = 0;

	// total amount bought so far
	uint256 propertyValue = 0;
	uint256 boughtSoFar = 0;
	uint256[] boughtEachBuyer;


	address payable public sender = buyer;
	address payable public _receiver = seller;

	bool sellerConsent = false;
	bool thisBuyerConsent = false;
	bool allBuyerConsent = false;
	bool propertyFilled = false; // equals true when boughtSoFar == propertyValue


	function deposit (address payable _receiver) external payable {
		require (msg.value > 0);
		buyer = msg.buyer;
		receiver = _receiver;
	}

	function viewApprover() external returns (address) {
		return approver;
	}

	function approve() external {
		// require(msg.sender == approver);
		// receiver.transfer(address(this).balance);

        if (sellerConsent && allBuyerConsent) {
            require(msg.buyer == approver);
    	    receiver.transfer(address(this).balance);
        }


	}

	function querySellerConsent () external returns (bool) {
	    // this would update the seller's consent variable if the seller (from frontend) agrees to transaction
	    return false;
	}

	function queryBuyerConsent () external returns (bool) {
	    // this would update the allBuyerConsent variable if all buyers sign to transaction
	    return false;
	}



	function addBuyer () {
	    // obtain the equity they desire (error check for valid equity)
	    // if valid, increment totalEquity and numBuyers

	    var currBuyerInput = 10000; // need to connect w/ frontend to access this variable
	    if (currBuyerEquity + boughtSoFar > propertyValue) {
	        // error handling
	    } else {
	        numBuyers += 1;
	        boughtSoFar += currBuyerInput;

	        if (boughtSoFar == propertyValue) {
	            propertyFilled = true;
	            allBuyerConsent =  true;
	        }

	    }

	}


	// to be called whenever any change to the contract is made

	function main () {

	    if (numBuyers == 0) {
	        var requestedNumBuyers = 0; // FIXME w/ input from first user
            boughtEachBuyer = new uint256[requestedNumBuyers];
            numBuyers += 1;
            buyers = new Address [numBuyers];
	    } else if (!sellerConsent && propertyFilled) {
	        // queries for seller's signature once max equity has been reached
	        sellerConsent = querySellerConsent() && propertyFilled && !allBuyerConsent
	        // queries for buyer's signature once seller has signed
	        allBuyerConsent = queryBuyerConsent();
	    } else if (sellerConsent && propertyFilled && allBuyerConsent) {
	        // initiates transaction once buyer has signed
	        approve();
	    }
	}


}
