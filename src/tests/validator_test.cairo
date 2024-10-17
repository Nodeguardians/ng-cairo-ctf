use snforge_std::{ 
    declare, 
    start_cheat_caller_address,
    stop_cheat_caller_address,
    ContractClassTrait
};

use src::contracts::sphinx::{ 
    ISphinxDispatcher, 
    ISphinxDispatcherTrait 
};
use src::contracts::utils::validator::{ 
    IValidatorDispatcher, 
    IValidatorDispatcherTrait
};


#[test]
fn test_contract_name() {
    let validator = deploy_validator();
    assert!(validator.contract_name(1) == 'Sphinx', "Unexpected contract name!");
}

#[test]
fn test_validate() {

    let alice = starknet::contract_address_const::<'AL1CE_ADDRE55'>();

    // 1. Deploy Validator
    let validator = deploy_validator();

    // 2. Deploy CTF Instance and ensure test returns false
    start_cheat_caller_address(validator.contract_address, alice);
    validator.deploy(1);
    assert!(!validator.test(alice, 1), "Validator should test false!");

    // 3. Simulate a valid solution
    let sphinx = ISphinxDispatcher {
        contract_address: validator.deployments(alice, 1)
    };
    sphinx.deal_damage(100);

    // 4. Ensure test returns true
    assert!(validator.test(alice, 1), "Validator should test true!");
}

// =============================
//  HELPER DEPLOYMENT FUNCTION 
// =============================

fn deploy_validator() -> IValidatorDispatcher {
    
    let sphinx_hash = declare("Sphinx").unwrap();
    let validator = declare("Validator").unwrap();

    let mut calldata: Array<felt252> = array![sphinx_hash.class_hash.into()];

    let (validator_address, _) = validator.deploy(@calldata).unwrap();

    IValidatorDispatcher { contract_address: validator_address }
    
}
