// represents the contract
// artifacts.require pulls in the smart contract code
const ApprovalContract = artifacts.require('../../contracts/ApprovalContract.sol');


contract('ApprovalContract', function (accounts) {
	// accounts = array of all 10 testing accounts -- stored local in truffle server
	

	it('initiates contract', async function () {
		// async function - waits for an asyncronous to happen, then treats as syncronous


		const contract = await ApprovalContract.deployed();
		const approver = await contract.approver.call();
		// async function waits for this "await" key word to call function

		assert.equal(approver, 0x5D77F68ca73c6Da523a8FB8314E34b1A37784ac9, "Approvers do not match.");
	})

	it ('takes a depost', async function () {
		const contract = await ApprovalContract.deployed();
		await contract.deposit(accounts[0], {value: 10, from: accounts[1]});

		// from web3 packahge
		// gets balance from contract address
		assert.equal(web3.eth.getBalance(contract.address), 1e+1, "amounts do not match");

	})

});