defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2019-11-07 18:00:00},
        ~N{2019-11-07 20:00:00}
      ],
      speaker: %{
        name: "Andrew Turley"
      },
      topic: "The Pony Language",
      location: %{
        url: "https://goo.gl/maps/cUUMbLpFb3Nq4Wiz5",
        address: "300 E 39th St, Kansas City, MO 64111",
        venue: "Plexpod Westport Commons, Annex A"
      },
      description: """
      Pony (ponylang.io) is a fast actor-based programming language that guarantees data safety. These data safety guarantees are built on reference capabilities, which control the way aliases are used in a way that prevents more than one actor from having access to mutable data.

      This talk will present an overview of the language and runtime with a focus on how it compares to other actor-based systems (like Elixir), followed by a look at some small programs that illustrate how Pony's data safety guarantees work.

      Andrew Turley is an engineer at Wallaroo Labs where he has been using Pony since 2016.
      """
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates from the past?

    # dt_from |> IO.inspect()

    from = Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY} - {h12}:{m} {AM}")
    to = Timex.format!(dt_to, "{h12}:{m} {AM}")

    meetup
    |> Map.merge(%{
      date_of: Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY}"),
      datetime_description: "#{from} to #{to}",
      location_description: "#{meetup.location.venue} - #{meetup.location.address}"
    })
  end
end
