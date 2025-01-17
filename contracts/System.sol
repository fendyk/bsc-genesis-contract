pragma solidity 0.6.4;

import "./interface/ISystemReward.sol";
import "./interface/IRelayerHub.sol";
import "./interface/ILightClient.sol";

contract System {

  bool public alreadyInit;

  uint32 public constant CODE_OK = 0;
  uint32 public constant ERROR_FAIL_DECODE = 100;

  uint8 constant public BIND_CHANNELID = 0x01;
  uint8 constant public TRANSFER_IN_CHANNELID = 0x02;
  uint8 constant public TRANSFER_OUT_CHANNELID = 0x03;
  uint8 constant public STAKING_CHANNELID = 0x08;
  uint8 constant public GOV_CHANNELID = 0x09;
  uint8 constant public SLASH_CHANNELID = 0x0b;
  uint16 constant public bscChainID = 0x0060;

  address public  VALIDATOR_CONTRACT_ADDR;
  address public  SLASH_CONTRACT_ADDR;
  address public  SYSTEM_REWARD_ADDR;
  address public  LIGHT_CLIENT_ADDR;
  address public  TOKEN_HUB_ADDR;
  address public INCENTIVIZE_ADDR;
  address public RELAYERHUB_CONTRACT_ADDR;
  address public GOV_HUB_ADDR;
  address public TOKEN_MANAGER_ADDR;
  address public CROSS_CHAIN_CONTRACT_ADDR;

  function updateContractAddr(address valAddr, address slashAddr, address rewardAddr, address lightAddr, address tokenHubAddr,
  address incentivizeAddr, address relayerHubAddr, address govHub, address tokenManagerAddr, address crossChain) external {
    VALIDATOR_CONTRACT_ADDR = valAddr;
    SLASH_CONTRACT_ADDR = slashAddr;
    SYSTEM_REWARD_ADDR = rewardAddr;
    LIGHT_CLIENT_ADDR = lightAddr;
    TOKEN_HUB_ADDR = tokenHubAddr;
    INCENTIVIZE_ADDR = incentivizeAddr;
    RELAYERHUB_CONTRACT_ADDR = relayerHubAddr;
    GOV_HUB_ADDR = govHub;
    TOKEN_MANAGER_ADDR = tokenManagerAddr;
    CROSS_CHAIN_CONTRACT_ADDR = crossChain;
  }

  address public constant SYSTEM_ADDRESS = 0x9fB29AAc15b9A4B7F17c3385939b007540f4d791;

  modifier onlyCoinbase() {
    require(msg.sender == SYSTEM_ADDRESS, "the message sender must be the block producer");
    _;
  }

  modifier onlyNotInit() {
    require(!alreadyInit, "the contract already init");
    _;
  }

  modifier onlyInit() {
    require(alreadyInit, "the contract not init yet");
    _;
  }

  modifier onlySlash() {
    require(msg.sender == SLASH_CONTRACT_ADDR, "the message sender must be slash contract");
    _;
  }

  modifier onlyTokenHub() {
    require(msg.sender == TOKEN_HUB_ADDR, "the message sender must be token hub contract");
    _;
  }

  modifier onlyGov() {
    require(msg.sender == GOV_HUB_ADDR, "the message sender must be governance contract");
    _;
  }

  modifier onlyValidatorContract() {
    require(msg.sender == VALIDATOR_CONTRACT_ADDR, "the message sender must be validatorSet contract");
    _;
  }

  modifier onlyCrossChainContract() {
    require(msg.sender == CROSS_CHAIN_CONTRACT_ADDR, "the message sender must be cross chain contract");
    _;
  }

  modifier onlyRelayerIncentivize() {
    require(msg.sender == INCENTIVIZE_ADDR, "the message sender must be incentivize contract");
    _;
  }

  modifier onlyRelayer() {
    require(IRelayerHub(RELAYERHUB_CONTRACT_ADDR).isRelayer(msg.sender), "the msg sender is not a relayer");
    _;
  }

  modifier onlyTokenManager() {
    require(msg.sender == TOKEN_MANAGER_ADDR, "the msg sender must be tokenManager");
    _;
  }

  // Not reliable, do not use when need strong verify
  function isContract(address addr) internal view returns (bool) {
    uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
  }
}
