# frozen_string_literal: true

require_relative '../vm_translator'
require_relative 'support/shared_examples_for_chapters'

describe 'chapter 8 tests' do
  context 'ProgramFlow' do
    context 'BasicLoop' do
      it_behaves_like 'a successful task', '08/ProgramFlow/BasicLoop'
    end
    context 'FibonacciSeries' do
      it_behaves_like 'a successful task', '08/ProgramFlow/FibonacciSeries'
    end
  end

  context 'FunctionCalls' do
    context 'FibonacciElement' do
      it_behaves_like 'a successful task',
                      '08/FunctionCalls/FibonacciElement',
                      apply_bootstrap_code: true
    end
    context 'NestedCall' do
      it_behaves_like 'a successful task',
                      '08/FunctionCalls/NestedCall',
                      apply_bootstrap_code: true
    end
    context 'SimpleFunction' do
      it_behaves_like 'a successful task', '08/FunctionCalls/SimpleFunction'
    end
    context 'StaticsTest' do
      it_behaves_like 'a successful task',
                      '08/FunctionCalls/StaticsTest',
                      apply_bootstrap_code: true
    end
  end
end
