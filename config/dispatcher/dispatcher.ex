defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  # layers [ :api, :frontend, :not_found ]

  @any %{}
  @json %{ accept: %{ json: true } }
  # @html %{ accept: %{ html: true } }

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #

  # match "/people/*path", @json do
  #   forward conn, path, "http://resource/people/"
  # end

  match "/personen/*path", @any do
    IO.inspect( conn, label: "conn for /personen" )
    forward conn, path, "http://resource/personen/"
  end

  match "/accounts/*path", @json do
    forward conn, path, "http://resource/accounts/"
  end

  match "/mandatarissen/*path", @json do
    forward conn, path, "http://resource/mandatarissen/"
  end

  match "/mandaten/*path", @any do
    forward conn, path, "http://resource/mandaten/"
  end

  match "/contact-punten/*path", @json do
    forward conn, path, "http://resource/contact-punten/"
  end

  match "/adressen/*path", @any do
    forward conn, path, "http://resource/adressen/"
  end
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  # get "/themes/*path", @any do
  #   forward conn, path, "http://resource/themes/"
  # end

  # match "/test/*path", %{ accept: [:json], layer: :api } do
  #   forward conn, path, "http://database/test/"
  # end

  options "/*_path" do
    send_resp( conn, 200, "Option calls are accepted by default" )
  end

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
