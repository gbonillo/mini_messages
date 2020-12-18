require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Messages" do
  explanation "Mini Messages"

  authentication :basic, :basic_auth_value
  #header "Content-Type", "application/json"
  header "Host", "localhost:3000"
  header "Accept", "application/json"
  header "Accept-Charset", "utf-8"
  #header "Connection", "keep-alive"

  let(:basic_auth_value) do
    ActionController::HttpAuthentication::Basic.encode_credentials(
      "user_f1@test.org", #users(:user_f1).email,
      "test" #users(:user_f1).password
    )
  end

  let(:u1) { User.find_by(name: "user_f1") }
  let(:u2) { User.find_by(name: "user_f2") }

  get "/" do
    example_request "00 - accueil répond et permet de récupérer les infos nécessaires aux POST" do
      expect(status).to eq(200)
    end
  end

  get "/users.json" do
    context "200" do
      example_request "01 - liste des utilisateurs" do
        expect(status).to eq(200)
      end
    end
  end

  get "/messages.json" do
    #fixtures :users
    parameter :view, type: :string, enum: ["thread", "recent"], default: ["recent"]

    context "200" do
      let(:view) { "recent" }
      example_request "02 - liste des messages récents de l'utilisateur" do
        #byebug
        expect(status).to eq(200)
      end
    end

    context "200" do
      let(:view) { "thread" }
      example_request "03 - liste des fils de discussions récents de l'utilisateur" do
        expect(status).to eq(200)
      end
    end
  end

  post "/messages.json" do
    #fixtures :users
    with_options scope: :message, with_example: true do
      parameter :content, "contenu du message", type: :string, required: true
      parameter :user_id, "id de l'auteur (DOIT être l'id de l'utilsateur courant!)", type: :integer, required: true
      parameter :dest_id, "id du destinataire", type: :integer, required: true
      parameter :is_public, "message public ?", type: :boolean, default: true
    end

    context "200" do
      example "04 - Creation d'un message" do
        request = {
          message: {
            content: "test message",
            user_id: u1.id,
            dest_id: u2.id,
            is_public: true,
          },
        }

        do_request(request)
        expect(status).to eq(201)
        #expect(response_body).to eq(expected_response)
      end
    end

    context "Invalid request" do
      example "05 - Erreur de création de message : unprocessable entity" do
        #fixtures :users
        request = {
          message: {
            content: "",
            user_id: u1.id,
            dest_id: u2.id,
            is_public: true,
          },
        }
        do_request(request)
        expect(status).to eq(422)
      end
    end
  end

  post "/messages/:id/reply.json" do
    #fixtures :users
    with_options scope: :message, with_example: true do
      parameter :content, "contenu du message", type: :string, required: true
      parameter :user_id, "id de l'auteur (DOIT être l'id de l'utilsateur courant!)", type: :integer, required: true
    end

    let(:id) { Message.find_by(dest_id: u1.id).id }

    context "200" do
      example "06 - Creation d'une réponse à un message" do
        request = {
          message: {
            content: "test message réponse",
            user_id: u1.id,
          },
        }

        do_request(request)
        expect(status).to eq(201)
        #expect(response_body).to eq(expected_response)
      end
    end

    context "Invalid request" do
      example "07 - Erreur de création de réponse à un message : unprocessable entity" do
        request = {
          message: {
            content: "",
            user_id: u1.id,
          },
        }
        do_request(request)
        expect(status).to eq(422)
      end
    end

    context "Invalid message reply context" do
      let(:id) { Message.find_by(dest_id: u2.id).id }

      example "08 - Erreur de création de réponse à un message : non autorisé" do
        explanation "Le destinataire du message initial n'est pas l'utilisateur courant ! "

        request = {
          message: {
            content: "Test de contenu de réponse",
            user_id: u1.id,
          },
        }
        do_request(request)
        expect(status).to eq(401)
      end
    end
  end
end
