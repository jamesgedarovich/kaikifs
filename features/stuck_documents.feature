@not_a_test
Feature: Stuck Documents

  Background:
    Given I am up top

  Scenario: Document Requeuer requeues a document successfully

    Given I am logged in
    And   I am on the "administration" tab
    When I click the "Document Operation" portal link
    And I slow down
    And I requeue all of the documents

