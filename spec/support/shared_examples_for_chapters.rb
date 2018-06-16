# frozen_string_literal: true

CPU_EMULATOR_PATH = '/Users/Dan/code/ecs/tools/CPUEmulator.sh'
PROJECT_FOLDER_PATH = '/Users/Dan/code/ecs/projects'

shared_examples 'a successful task' do |file_path|
  test_folder_path = File.join(PROJECT_FOLDER_PATH, file_path)

  file_name = file_path.split('/').last

  it 'complies' do
    expect do
      VmTranslator.translate("#{test_folder_path}/#{file_name}.vm")
    end.not_to raise_error
  end

  it 'succeeds' do
    expect(
      system("#{CPU_EMULATOR_PATH} #{test_folder_path}/#{file_name}.tst")
    ).to eq(true)
  end
end
