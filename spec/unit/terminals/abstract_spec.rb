# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Abstract do
  let(:env) { {"TERM_PROGRAM" => "terminal"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  describe "#link?" do
    it "raises an error when the name? method isn't implemented" do
      stub_const("Terminal", Class.new(described_class))
      terminal = Terminal.new(semantic_version, env)

      expect {
        terminal.link?
      }.to raise_error(
        TTY::Link::AbstractMethodError,
        "the Terminal class must implement the `name?` method"
      )
    end

    it "raises an error when the version? method isn't implemented" do
      stub_const("Terminal", Class.new(described_class) do
        def name?
          true
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect {
        terminal.link?
      }.to raise_error(
        TTY::Link::AbstractMethodError,
        "the Terminal class must implement the `version?` method"
      )
    end

    it "supports links when the name? and version? match the terminal" do
      stub_const("Terminal", Class.new(described_class) do
        def name?
          true
        end

        def version?
          true
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect(terminal.link?).to eq(true)
    end

    it "doesn't support links when the name? doesn't match the terminal" do
      stub_const("Terminal", Class.new(described_class) do
        def name?
          false
        end

        def version?
          true
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect(terminal.link?).to eq(false)
    end

    it "doesn't support links when the version? doesn't match the terminal" do
      stub_const("Terminal", Class.new(described_class) do
        def name?
          true
        end

        def version?
          false
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect(terminal.link?).to eq(false)
    end
  end

  describe "#env" do
    it "accesses the environment attribute reader in a subclass" do
      stub_const("Terminal", Class.new(described_class) do
        def environment
          env
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect(terminal.environment).to eq(env)
    end
  end

  describe "#semantic_version" do
    it "accesses the semantic version creator in a subclass" do
      stub_const("Terminal", Class.new(described_class) do
        def version
          semantic_version("1.2.3")
        end
      end)
      terminal = Terminal.new(semantic_version, env)

      expect(terminal.version.inspect).to eq("1.2.3")
    end
  end

  describe "#term" do
    it "accesses the term environment variable in a subclass" do
      env_with_term = {"TERM" => "terminal"}
      stub_const("Terminal", Class.new(described_class) do
        def name
          term
        end
      end)
      terminal = Terminal.new(semantic_version, env_with_term)

      expect(terminal.name).to eq("terminal")
    end
  end

  describe "#term_program" do
    it "accesses the term program environment variable in a subclass" do
      env_with_term_program = {"TERM_PROGRAM" => "terminal"}
      stub_const("Terminal", Class.new(described_class) do
        def name
          term_program
        end
      end)
      terminal = Terminal.new(semantic_version, env_with_term_program)

      expect(terminal.name).to eq("terminal")
    end
  end

  describe "#term_program_version" do
    it "accesses the term program version environment variable in a subclass" do
      env_with_term_program_version = {"TERM_PROGRAM_VERSION" => "1.2.3"}
      stub_const("Terminal", Class.new(described_class) do
        def version
          term_program_version
        end
      end)
      terminal = Terminal.new(semantic_version, env_with_term_program_version)

      expect(terminal.version).to eq("1.2.3")
    end
  end
end
