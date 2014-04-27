questionTemplate = _.template("
<li>
  <%= question %><br/>
  <div class='btn-group response' data-toggle='buttons'>
    <label class='btn btn-primary'>
      <input type='radio' class='response' name='response<%= index %>' value=1> Not at all true
    </label>
    <label class='btn btn-primary'>
      <input type='radio' class='response' name='response<%= index %>' value=2> Rarely
    </label>
    <label class='btn btn-primary'>
      <input type='radio' class='response' name='response<%= index %>' value=3> Sometimes
    </label>
    <label class='btn btn-primary'>
      <input type='radio' class='response' name='response<%= index %>' value=4> Often
    </label>
    <label class='btn btn-primary'>
      <input type='radio' class='response' name='response<%= index %>' value=5> Very true
    </label>
  </div>
</li>
")

scoreTemplate = _.template("
  <h2>Your Results</h2>
  <div id='impostorMeter'></div>
  <h3>Explanation</h3>
    <p>The Impostor Test was developed to help individuals determine whether or not they have Impostor characteristics and, if so, to what extent they are suffering.</p>
    <dl class='dl-horizontal'>
      <dt>0-40</dt>
      <dd>None to mild Impostorism</dd>
      <dt>41-60</dt>
      <dd>Moderate Impostorism</dd>
      <dt>61-80</dt>
      <dd>Significant Impostorism</dd>
      <dt>81-100</dt>
      <dd>Intense Impostorism</dd>
    </dl>
    <p><strong>The higher your score, the more frequently and seriously Impostor Syndrome interferes in your life.</strong></p>
    <h3>Share Your Score</h3>
    <p>Consider helping build awareness of Impostor Syndrome by sharing your score:</p>
    <p>
      <a href='https://twitter.com/intent/tweet?button_hashtag=ImpostorSyndrome&text=My%20level%20on%20the%20Clance%20Impostor%20Scale%20is%20<%= score %>%20(of%20100).%20Learn%20yours%20at' class='twitter-hashtag-button' data-size='large' data-related='nmeans' data-url='http://impostortest.nickol.as/'>Tweet #ImpostorSyndrome</a>
    </p>
");

$ =>
  _.each(App.questions, (question, index) ->
    $('#questions ol').append(questionTemplate(index: index, question: question))
  )

  $('button#calculate').click( (event) ->
    event.preventDefault()
    values = _.map($("input.response:checked"), (el) -> $(el).val())
    score = _.reduce(values, (memo, response) ->
      return memo + parseInt(response)
    , 0)

    $('body .content').html(scoreTemplate(score: score));

    $.jqplot('impostorMeter',[[score]],{
      seriesDefaults: {
        renderer: $.jqplot.MeterGaugeRenderer,
        rendererOptions: {
          label: 'Your Score: ' + score,
          labelPosition: 'bottom',
          intervals: [40,60,80,100],
          intervalColors: ["#35A909","#C7B80A","#C76D0A","#B80A21"]
        }
      }
    })

    window.scrollTo(0,0)
    ((d,s,id) ->
      fjs = d.getElementsByTagName(s)[0]
      p = if /^http:/.test(d.location) then 'http' else 'https'
      if(!d.getElementById(id))
        js=d.createElement(s)
        js.id=id
        js.src=p+'://platform.twitter.com/widgets.js'
        fjs.parentNode.insertBefore(js,fjs)
    )(document, 'script', 'twitter-wjs')
  );
