contract Escrow { 
  address buyer;
  address seller; 
  address agent; 
  
  function Escrow(address _agent, address _seller) { 
    // In this simple example, the person sending money is the buyer and sets up the initial contract 
    buyer = msg.sender; 
    agent = _agent; 
    seller = _seller; 
  } 

  function release() { 
    if (msg.sender == agent) 
      suicide(seller); // Send all funds to seller 
    else throw; 
  } 

  function cancel() { 
    if (msg.sender == agent) 
      suicide(buyer); // Cancel escrow and return all funds to buyer    
    else throw; 
  } 
}
