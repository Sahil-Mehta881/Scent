pragma solidity ^0.5.16;

contract ApprovalContract {

	address public sender;
	address payable public receiver;
	address public approver = 0xD16d5B0FBC562B40F59B1aC59680B316eD310305;


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
