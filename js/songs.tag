<songs>
  <div class="pure-menu pure-menu-scrollable song-list"
    if={ requested_tracks.length &&
      (active === 'confirm' || active === 'song_request') }>
    <span class="pure-menu-link song-request-heading" onclick={ toggleOpen }>
      Number of songs requested: { requested_tracks.length } (Click to 
      { open ? 'hide' : 'show' })
    </span>

    <ul class="pure-menu-list" if={ open }>
      <li class="pure-menu-item">
        <p> Click songs to remove </p>
      </li>
      <li each={ requested_tracks } class="pure-menu-item">
        <a class="pure-menu-link" onclick={ parent.delete_track }>
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
    this.requested_tracks = [];
    this.open = true;

    riot.store.on('change_state', function(state) {
      this.active = state;
      this.update()
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.update();
    }.bind(this));

    riot.store.on('got_songs', function(tracks) {
      this.requested_tracks = tracks;
      this.update();
    }.bind(this));

    var find_song_index = function(song_id) {
      for (var i = 0; i < this.requested_tracks.length; i++) {
        if (this.requested_tracks[i].song_id == song_id) {
          return i;
        }
      }
      return -1;
    }.bind(this);

    riot.store.on('add_track', function(track) {
      var index = find_song_index(track.song_id);
      if (index < 0) {
        this.requested_tracks.push(track);
        this.update();
      }
    }.bind(this));

    toggleOpen(e) {
      this.open = !this.open;
    }

    delete_track(e) {
      var track = e.item;
      $.ajax({
        url: 'backend/songs',
        type: 'DELETE',
        contentType: 'application/json',
        data: JSON.stringify({
          'song_id': track.song_id,
          'pass_code': this.passphrase
        }),
        success: function(response) {
          var index = find_song_index(response.song_id);
          this.requested_tracks.splice(index, 1);
          this.update();
        }.bind(this)
      });
    }
  </script>
</songs>
