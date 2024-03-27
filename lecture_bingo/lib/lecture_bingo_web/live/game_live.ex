defmodule LectureBingoWeb.GameLive do
  import Process, only: [send_after: 3]
  import LectureBingo.Games.Game
  alias LectureBingo.Games
  use Phoenix.LiveView
  use LectureBingoWeb, :live_view
  alias LectureBingo.Accounts
  alias LectureBingo.Games
  alias LectureBingo.Games.Game






  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    # {:ok, game} = Games.start_game(socket.assigns.current_user)
    # socket = assign(socket, current_user: user, game: game)
    # {:ok, socket}
    {:ok, game} = Games.start_game(user)
    socket = assign(socket, current_user: user, game: game)
    {:ok, socket}
  end


  def render(assigns) do
    ~L"""
    <div>
      <h1 class="text-4xl font-bold mb-10 mt-8">Lecture Bingo</h1>
      <%= for incident <- assigns.game.state do %>
        <div class="flex items-center justify-start space-x-4">
          <div class="bg-black text-white rounded">
            <button phx-click="toggle_incident" phx-value-id="<%= incident.id %>"
                    class="w-24 h-10 <%= if incident.occurred, do: "bg-blue-500", else: "bg-black" %> rounded">
              <%= if incident.occurred, do: "Occurred!", else: "Waiting.." %>
            </button>
          </div>
          <div class="flex flex-col">
            <span class="font-bold"><%= incident.title %></span>
            <span><%= incident.description %></span>
          </div>
        </div>
      <% end %>
      <%= if Game.victorious(assigns.game) do %>
        <div class="fixed bottom-0 left-0 w-full p-4 bg-green-500 text-white text-center">
          You Won!
        </div>
      <% end %>
      <div class="fixed top-16 right-0 p-4">
  <button phx-click="new_game" class="bg-black hover:bg-gray-700 text-white px-4 py-2 rounded">New Game</button>
</div>
    </div>
    """
  end



  def handle_info(:start_new_game, socket) do
    {:ok, new_game} = Games.start_game(socket.assigns.current_user)
    {:noreply, assign(socket, game: new_game, won: false)}
  end


  def handle_event("new_game", _, socket) do
    {:ok, game} = Games.start_game(socket.assigns.current_user)
    {:noreply, assign(socket, game: game)}
    end

    def handle_event("toggle_incident", %{"id" => id}, socket) do
      updated_game = Games.toggle_incident(socket.assigns.game, id)
      won = Game.victorious(updated_game)

      if won do
        send_after(self(), :start_new_game, 2000) # Add a 2-second delay before starting a new game
        {:noreply, assign(socket, game: updated_game, won: won)}
      else
        {:noreply, assign(socket, game: updated_game, won: won)}
      end
    end
end
