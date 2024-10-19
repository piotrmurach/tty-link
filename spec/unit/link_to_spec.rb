# frozen_string_literal: true

RSpec.describe TTY::Link do
  let(:env) {
    {
      "TERM_PROGRAM" => "iTerm.app",
      "TERM_PROGRAM_VERSION" => "4.3.2"
    }
  }
  let(:output) { double(:output, tty?: true) }

  describe ".link_to" do
    context "when unsupported terminal" do
      it "createa a terminal link replacement" do
        linked = described_class.link_to(
          "TTY Toolkit", "https://ttytoolkit.org", env: {}, output: output
        )

        expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
      end

      it "creates a terminal link replacement from a single argument" do
        linked = described_class.link_to(
          "https://ttytoolkit.org", env: {}, output: output
        )

        expect(linked).to eql(
          "https://ttytoolkit.org -> https://ttytoolkit.org"
        )
      end

      context "with :attrs option" do
        it "creates a terminal link replacement excluding any attributes" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org", attrs: {
              id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
            }, env: {}, output: output
          )

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end
      end

      context "with :hyperlink option" do
        it "creates a terminal link with an always value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, hyperlink: :always, output: output
          )

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link replacement with an auto value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, hyperlink: :auto, output: output
          )

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "creates a terminal link replacement with a never value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, hyperlink: :never, output: output
          )

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "fails to create a terminal link with an invalid value" do
          expect {
            described_class.link_to(
              "TTY Toolkit", "https://ttytoolkit.org",
              env: {}, hyperlink: :invalid, output: output
            )
          }.to raise_error(TTY::Link::ValueError)
        end
      end

      context "with :plain option" do
        it "creates a terminal link replacement with name and url tokens" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, output: output, plain: ":name (:url)"
          )

          expect(linked).to eql("TTY Toolkit (https://ttytoolkit.org)")
        end

        it "creates a terminal link replacement with only a name token" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, output: output, plain: ":name"
          )

          expect(linked).to eql("TTY Toolkit")
        end

        it "creates a terminal link replacement with only a url token" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, output: output, plain: ":url"
          )

          expect(linked).to eql("https://ttytoolkit.org")
        end

        it "creates a terminal link replacement with no tokens" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: {}, output: output, plain: "text"
          )

          expect(linked).to eql("text")
        end
      end
    end

    context "when supported terminal" do
      it "creates a terminal link" do
        linked = described_class.link_to(
          "TTY Toolkit", "https://ttytoolkit.org", env: env, output: output
        )

        expect(linked)
          .to eql("\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a")
      end

      it "creates a terminal link from a single argument" do
        linked = described_class.link_to(
          "https://ttytoolkit.org", env: env, output: output
        )

        expect(linked).to eql(
          "\e]8;;https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
        )
      end

      context "with :attrs option" do
        it "creates a terminal link with an id attribute" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            attrs: {id: "tty-toolkit"}, env: env, output: output
          )

          expect(linked).to eql(
            "\e]8;id=tty-toolkit;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link with the id, lang and title attributes" do
          linked = described_class.link_to(
            "https://ttytoolkit.org", attrs: {
              id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
            }, env: env, output: output
          )

          expect(linked).to eql(
            "\e]8;id=tty-toolkit:lang=en:title=Terminal Apps The Easy Way;" \
            "https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
          )
        end
      end

      context "with :hyperlink option" do
        it "creates a terminal link with an always value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: env, hyperlink: :always, output: output
          )

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link with an auto value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: env, hyperlink: :auto, output: output
          )

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link replacement with a never value" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: env, hyperlink: :never, output: output
          )

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "fails to create a terminal link with an invalid value" do
          expect {
            described_class.link_to(
              "TTY Toolkit", "https://ttytoolkit.org",
              env: env, hyperlink: :invalid, output: output
            )
          }.to raise_error(TTY::Link::ValueError)
        end
      end

      context "with :plain option" do
        it "creates a terminal link excluding a plain template" do
          linked = described_class.link_to(
            "TTY Toolkit", "https://ttytoolkit.org",
            env: env, output: output, plain: ":name (:url)"
          )

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end
      end
    end
  end

  describe "#link_to" do
    context "when unsupported terminal" do
      it "creates a terminal link replacement" do
        link = described_class.new(env: {}, output: output)
        linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

        expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
      end

      it "creates a terminal link replacement from a single argument" do
        link = described_class.new(env: {}, output: output)
        linked = link.link_to("https://ttytoolkit.org")

        expect(linked).to eql(
          "https://ttytoolkit.org -> https://ttytoolkit.org"
        )
      end

      context "with :attrs option" do
        it "creates a terminal link replacement excluding any attributes" do
          link = described_class.new(env: {}, output: output)
          linked = link.link_to(
            "TTY Toolkit", "https://ttytoolkit.org", attrs: {
              id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
            }
          )

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end
      end

      context "with :hyperlink option" do
        it "creates a terminal link with an always value" do
          link = described_class.new(
            env: {}, hyperlink: :always, output: output
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link replacement with an auto value" do
          link = described_class.new(env: {}, hyperlink: :auto, output: output)
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "creates a terminal link replacement with a never value" do
          link = described_class.new(env: {}, hyperlink: :never, output: output)
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "fails to create a terminal link with an invalid value" do
          expect {
            described_class.new(env: {}, hyperlink: :invalid, output: output)
          }.to raise_error(TTY::Link::ValueError)
        end
      end

      context "with :plain option" do
        it "creates a terminal link replacement with name and url tokens" do
          link = described_class.new(
            env: {}, output: output, plain: ":name (:url)"
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("TTY Toolkit (https://ttytoolkit.org)")
        end

        it "creates a terminal link replacement with only a name token" do
          link = described_class.new(env: {}, output: output, plain: ":name")
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("TTY Toolkit")
        end

        it "creates a terminal link replacement with only a url token" do
          link = described_class.new(env: {}, output: output, plain: ":url")
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("https://ttytoolkit.org")
        end

        it "creates a terminal link replacement with no tokens" do
          link = described_class.new(env: {}, output: output, plain: "text")
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("text")
        end
      end
    end

    context "when supported terminal" do
      it "creates a terminal link" do
        link = described_class.new(env: env, output: output)
        linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

        expect(linked)
          .to eql("\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a")
      end

      it "creates a terminal link from a single argument" do
        link = described_class.new(env: env, output: output)
        linked = link.link_to("https://ttytoolkit.org")

        expect(linked).to eql(
          "\e]8;;https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
        )
      end

      context "with :attrs option" do
        it "creates a terminal link with an id attribute" do
          link = described_class.new(env: env, output: output)
          linked = link.link_to(
            "TTY Toolkit", "https://ttytoolkit.org", attrs: {id: "tty-toolkit"}
          )

          expect(linked).to eql(
            "\e]8;id=tty-toolkit;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link with the id, lang and title attributes" do
          link = described_class.new(env: env, output: output)
          linked = link.link_to(
            "https://ttytoolkit.org", attrs: {
              id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
            }
          )

          expect(linked).to eql(
            "\e]8;id=tty-toolkit:lang=en:title=Terminal Apps The Easy Way;" \
            "https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
          )
        end
      end

      context "with :hyperlink option" do
        it "creates a terminal link with an always value" do
          link = described_class.new(
            env: env, hyperlink: :always, output: output
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link with an auto value" do
          link = described_class.new(
            env: env, hyperlink: :auto, output: output
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end

        it "creates a terminal link replacement with a never value" do
          link = described_class.new(
            env: env, hyperlink: :never, output: output
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
        end

        it "fails to create a terminal link with an invalid value" do
          expect {
            described_class.new(env: env, hyperlink: :invalid, output: output)
          }.to raise_error(TTY::Link::ValueError)
        end
      end

      context "with :plain option" do
        it "creates a terminal link excluding a plain template" do
          link = described_class.new(
            env: env, output: output, plain: ":name (:url)"
          )
          linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

          expect(linked).to eql(
            "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
          )
        end
      end
    end
  end
end
