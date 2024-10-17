# Cairo CTF Template

This is a template for submitting a custom Cairo CTF challenge. The template enforces a consistent structure that is compatible with the Node Guardians platform.

A complete submission consists of:

1. A set of contracts in `src/contracts/` that define the challenge.
2. Unit tests in `src/tests/` that ensures the contracts are working as expected.
3. A description of the challenge, in `description/part1.md`.
4. A explanation of the solution to the challenge, in `solution/walkthrough1.md`.

Each of these components is described in more detail below.

## Contracts

The contracts for the challenge should be placed in the `src/contracts/` directory. An example contract is provided in `src/contracts/Sphinx.cairo`.

Along with the contracts to hack, you should also implement a `Validator` contract that manages the challenge state for each user. The API for `Validator` is found in `src/contracts/utils/Validator.cairo`.

## Tests

The tests for the contracts should be placed in the `src/tests/` directory. Unit tests are optional, except for the `Validator` contract, which must be tested. Example tests are provided in `src/tests/validator_test.cairo`.

You can run tests using either Cairo native or Starknet Foundry.

## Description

The description of the challenge should be placed in `description/part1.md`. This description will be shown to the user when they start the challenge.

An example of how descriptions will look like can be found [here](https://nodeguardians.io/adventure/vanity-address/part-1).

> **Note:** You will not have to write a storyline or provide art. We will help take care of that!

## Solution

Lastly, provide an explanation of the solution to the challenge in `solution/walkthrough1.md`. This will be for internal reference only and will not be shown to the user.