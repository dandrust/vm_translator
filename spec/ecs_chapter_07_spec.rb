# frozen_string_literal: true

require_relative '../vm_translator'
require_relative 'support/shared_examples_for_chapters'

describe 'chapter 7 tests' do
  context 'MemoryAccess' do
    context 'BasicTest' do
      it_behaves_like 'a successful task', '07/MemoryAccess/BasicTest'
    end
    context 'PointerTest' do
      it_behaves_like 'a successful task', '07/MemoryAccess/PointerTest'
    end
    context 'StaticTest' do
      it_behaves_like 'a successful task', '07/MemoryAccess/StaticTest'
    end
  end

  context 'StackArithmetic' do
    context 'SimpleAdd' do
      it_behaves_like 'a successful task', '07/StackArithmetic/SimpleAdd'
    end
    context 'StackTest' do
      it_behaves_like 'a successful task', '07/StackArithmetic/StackTest'
    end
  end
end
