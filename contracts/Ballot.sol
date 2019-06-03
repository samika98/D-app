pragma solidity >=0.4.21 <0.6.0;

contract Ballot {
    struct Individual {
    	bool selected;
    	string name;

    }
    int counter = 0;
    int checker = 0;
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
       // uint VoterId;
    }
    uint id = 0;
    struct Proposal {
        uint voteCount;
    }
   enum Stage {Init, RegV, RegI, Vote}
   Stage public stage = Stage.Init;
    
    address chairperson;
    mapping(address => Voter) voters;
    mapping(address => Individual) individuals;
  
    Proposal[] proposals;

    
  
    /// Create a new ballot with $(_numProposals) different proposals.
    constructor(uint8 _numProposals ) public  {
        chairperson = msg.sender;
        voters[chairperson].weight = 1; 
        proposals.length = _numProposals;
        stage = Stage.RegV;
       // startTime = now;
    }

   
    function registerVoter(address toVoter) public {
        if (stage != Stage.RegV) {return;}
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        stage = Stage.RegI;
        counter++;
       // voters[toVoter].VoterId = ++id;

       // if (now > (startTime+ 10 seconds)) {stage = Stage.Vote; startTime = now;}        
    }

function registerIndividual(address toIndividual , address toVoter) public {
        if (stage != Stage.RegI) {return;}
      
        if (msg.sender != chairperson ) return ;
        if(individuals[toIndividual].selected == true) return;
        

        voters[toVoter].weight = voters[toVoter].weight + 1;
     
     
        individuals[toIndividual].selected = true;
            stage = Stage.Vote;        
    }
    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public  {
        if (stage != Stage.Vote) {return;}
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;   
        proposals[toProposal].voteCount += sender.weight;
        checker++;
        //if(checker==counter)stage = Stage.Done; 
      //  stage = Stage.Done;     because after one vote only the state will be changed .. should not happen
      // better method is written in the line above but is commented out two vars checker and counter are created
        
    }

    function winningProposal() public view returns (uint8 _winningProposal) {
      // if(stage != Stage.Done) {return 0 ;}
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
       
    }
}