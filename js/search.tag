<search>
  <div class="pure-g">
    <div class="pure-u-1" if={ active === 'song_request' }>
      <p>Search for songs to request:</p>
    </div>
    <form class="pure-form pure-u-1" if={ active === 'song_request' }
      onsubmit={ query_lastfm }>
      <fieldset class="pure-group">
        <input type="text" class="pure-input-1" placeholder="Track title (required)"
          ref="track" required/>
        <input type="text" class="pure-input-1" placeholder="Artist"
          ref="artist" />
      </fieldset>
      <button type="submit" class="pure-button pure-input-1 pure-button-primary">
        Search
      </button>
    </form>
  </div>

  <script>
    riot.store.on('change_state', function(state) {
      this.active = state;
      this.update()
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.update();
    }.bind(this));

    query_lastfm(e) {
      e.preventDefault();
      $.get('backend/search', {
          'pass_code': this.passphrase,
          'track': this.refs.track.value,
          'artist': this.refs.artist.value,
        }, function(response) {
          riot.store.trigger('search_results', response.tracks);
        }.bind(this)
      );
    }
  </script>
</search>
