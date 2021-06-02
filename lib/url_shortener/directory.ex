defmodule UrlShortener.Directory do
  @moduledoc """
  The Directory context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias UrlShortener.Repo


  alias UrlShortener.Accounts.User
  alias UrlShortener.Directory.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    links = Repo.all(Link)
    |> Repo.preload(:clicks)
    links
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id) do
    Link
    |> Repo.get!(id)
    |> Repo.preload(:clicks)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Link{} = link} -> {:ok, Repo.preload(link, :clicks)}
      error -> error
    end
  end

  def create_user_link(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:links)
    |> Link.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Link{} =link} -> {:ok, Repo.preload(link, :clicks)}
      error -> error
    end
  end
  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  # Get Links created by
  # a user

  def get_user_links(user_id) do
    query = from(Link, where: [user_id: ^user_id], select: [:original_link, :short_link, :description, :id])
    case Repo.all(query) do
      nil ->
        {:error, :not_found}
      links ->
        {:ok, links}
    end
  end

  # Get Link from the hash
  # for redirection

  def get_link_from_hash(hash_id) do
    case Repo.get_by(Link, hash_id: hash_id) do
      nil ->
        {:error, :not_found}
      link ->
        {:ok, link}
    end
  end

  alias UrlShortener.Directory.Click

  @doc """
  Returns the list of clicks.

  ## Examples

      iex> list_clicks()
      [%Click{}, ...]

  """
  def list_clicks do
    Repo.all(Click)
  end

  @doc """
  Gets a single click.

  Raises `Ecto.NoResultsError` if the Click does not exist.

  ## Examples

      iex> get_click!(123)
      %Click{}

      iex> get_click!(456)
      ** (Ecto.NoResultsError)

  """
  def get_click!(id), do: Repo.get!(Click, id)

  @doc """
  Creates a click.

  ## Examples

      iex> create_click(%{field: value})
      {:ok, %Click{}}

      iex> create_click(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_click(%Link{} = link, attrs \\ %{}) do
    link
    |> Ecto.build_assoc(:clicks)
    |> Click.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a click.

  ## Examples

      iex> update_click(click, %{field: new_value})
      {:ok, %Click{}}

      iex> update_click(click, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_click(%Click{} = click, attrs) do
    click
    |> Click.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a click.

  ## Examples

      iex> delete_click(click)
      {:ok, %Click{}}

      iex> delete_click(click)
      {:error, %Ecto.Changeset{}}

  """
  def delete_click(%Click{} = click) do
    Repo.delete(click)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking click changes.

  ## Examples

      iex> change_click(click)
      %Ecto.Changeset{data: %Click{}}

  """
  def change_click(%Click{} = click, attrs \\ %{}) do
    Click.changeset(click, attrs)
  end
end
