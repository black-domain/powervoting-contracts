# Compilation of the PowerVoting

## 1. Obtain the code for the Oracle Contract, with the repository branch set to: bob

```python
git clone https://github.com/black-domain/powervoting-contracts.git
```

## 2. *Switch branch and enter the contract directory*

```python
git checkout bob
cd contract
```

## 3. Copy the code to[Remix](https://remix.ethereum.org/).

![Untitled](img/1.png)

## 4. Open the PowerVoting-bob.sol file and compile it.

![Untitled](img/2.png)

## 5. Connect to MetaMask and switch to the Bob network.

## 6. After checking 'Deploy with Proxy' and entering the address of the Oracle contract, click the 'Deploy' button.

![Untitled](img/3.png)

## 7. After deployment, there are two contracts: POWERVOTING is the logic contract, and ERC1967PROXY is the proxy contract.

![Untitled](img/4.png)