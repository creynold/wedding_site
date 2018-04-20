<search>
  <div class="pure-g">
    <div class="pure-u-1" if={ passphrase_entered }>
      <p>Search for songs to request:</p>
    </div>
    <form class="pure-form pure-u-1" if={ passphrase_entered }
      onsubmit={ query_lastfm }>
      <fieldset class="pure-group">
        <input type="text" class="pure-input-1" placeholder="Track title"
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
    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.passphrase_entered = true;
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
