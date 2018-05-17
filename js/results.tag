<results>
  <div if={ !tracks && active === 'song_request' }>
    <p> We want to hear what you want to hear! <p>
    <p> Request some songs by searching to the left.<p>
  </div>
  <div class="pure-menu pure-menu-scrollable song-list"
    if={ tracks && active === 'song_request' }>
    <span class="pure-menu-heading">Search Results (click to add request)</span>

    <ul class="pure-menu-list">
      <li each={ tracks } class="pure-menu-item">
        <a class="pure-menu-link" onclick={ parent.add_track }>
          <div class="pure-u-1-5">
            <img src={ image_url } />
          </div>
          <div class="pure-u-4-5 song-data">
            <p> Title: { track } </p>
            <p> Artist: { artist } </p>
            <p if={ album }> Album: { album } </p>
          </div>
        </a>
      </li>
    </ul>
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

    riot.store.on('search_results', function(tracks) {
      this.tracks = tracks;
      this.update();
    }.bind(this));

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
</results>
