<search>
  <form class="pure-form rsvp-form" if={ passphrase_entered }
    onsubmit={ query_lastfm }>
    <fieldset class="pure-group">
      <input type="text" class="pure-input-1" placeholder="Track title"
        ref="track" required/>
      <input type="text" class="pure-input-1" placeholder="Artist"
        ref="artist" />
    </fieldset>
    <button type="submit" class="pure-button pure-input-1 pure-button-primary">
      Enter
    </button>
  </form>
  <div class="pure-menu" if={ tracks }>
    <span class="pure-menu-heading">Search Results</span>

    <ul class="pure-menu-list">
      <li each={ tracks } class="pure-menu-item">
        <a class="pure-menu-link" onclick={ parent.add_track }>
          <div class="pure-u-1-5">
            <img src={ image_url } />
          </div>
          <div class="pure-u-4-5">
            <p> Title: { track } </p>
            <p> Artist: { artist } </p>
            <p if={ album }> Album: { album } </p>
          </div>
        </a>
      </li>
    </ul>
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
          this.tracks = response.tracks;
          this.update();
        }.bind(this)
      );
    }

    add_track(e) {
      var track = e.item;
      $.ajax({
        url: 'backend/songs',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
          'track': track.track,
          'artist': track.artist,
          'album': track.album,
          'image_url': track.image_url,
          'pass_code': this.passphrase
        }),
        success: function(response) {
          riot.store.trigger('add_track', response);
        }.bind(this)
      });
    }
  </script>
</search>
