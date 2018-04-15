<rsvp>
  <form class="pure-form rsvp-form" if={ !passphrase_entered }
    onsubmit={ submit_passphrase }>
    <input type="text" class="pure-input-1" placeholder="Invite Passphrase"
      ref="passphrase" required>
    <button type="submit" class="pure-button pure-input-1 pure-button-primary">
      Enter
    </button>
  </form>
  <form class="pure-form rsvp-form" if={ passphrase_entered }
    onsubmit={ submit_rsvp }>
    <fieldset class="pure-group">
      <input type="email" class="pure-input-1" placeholder="Email"
        value={ email } ref="email" required/>
      <input type="text" class="pure-input-1" placeholder="First Name"
        value={ first_name } ref="first_name" required/>
      <input type="text" class="pure-input-1" placeholder="Last Name"
        value={ last_name } ref="last_name" required/>
    </fieldset>
    <button type="submit" class="pure-button pure-input-1 pure-button-primary">
      Enter
    </button>
  </form>
  <div class="pure-menu" if={ requested_tracks.length }>
    <span class="pure-menu-heading">Requested Songs</span>

    <ul class="pure-menu-list">
      <li each={ requested_tracks } class="pure-menu-item">
        <a class="pure-menu-link" onclick={ parent.delete_track }>
          <div class="pure-u-1-5">
            <img src={ image_url } />
          </div>
          <div class="pure-u-4-5">
            <p> Title: { track } </p>
            <p> Artist: { artist } </p>
          </div>
        </a>
      </li>
    </ul>
  </div>
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
          </div>
        </a>
      </li>
    </ul>
  </div>

  <script>
    this.passphrase_entered = false;
    this.passphrase = '';
    this.requested_tracks = [];

    submit_passphrase(e) {
      e.preventDefault();
      this.passphrase = this.refs.passphrase.value;

      $.get('backend/invites', {'pass_code': this.passphrase},
        function (response) {
          this.first_name = response.first_name;
          this.last_name = response.last_name;
          this.email = response.email;
          this.passphrase_entered = true;
          this.update();
        }.bind(this)
      );

      $.get('backend/songs', {'pass_code': this.passphrase},
        function (response) {
          console.log(response);
          this.requested_tracks = response.tracks;
          this.update();
        }.bind(this)
      );
    }

    submit_rsvp(e) {
      e.preventDefault();
      $.ajax({
        url: 'backend/invites',
        type: 'PUT',
        contentType: "application/json",
        data: JSON.stringify({
          first_name: this.refs.first_name.value,
          last_name: this.refs.last_name.value,
          email: this.refs.email.value,
          pass_code: this.passphrase
        }),
        success: function(response) {
          console.log(response);
        }
     });
    }

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
          'image_url': track.image_url,
          'pass_code': this.passphrase
        }),
        success: function(response) {
          this.requested_tracks.push(response);
          console.log(response);
          this.update();
        }.bind(this)
      });
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
          for (var i = 0; i < this.requested_tracks.length; i++) {
            if (this.requested_tracks[i].song_id == response.song_id) {
              this.requested_tracks.splice(i, 1);
              break;
            }
          }
          console.log(response);
          this.update();
        }.bind(this)
      });
    }
  </script>
</rsvp>
