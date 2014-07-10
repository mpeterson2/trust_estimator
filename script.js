var colors = ["#4433AA",
              "#729544",
              "#957244",
              "#F26223",
              "#AA3344",
              "#442733",
              "#DD00DD",
              "#8822AA",
              "#DD2222",
              "#444",
              "#456789",
              "#829DD2",
              "#A34203",
              "#FF53A1",
              "#33AA33",
              "#FF3333",
              "#5BABE8",
              "#BABE85",
              "#852314",
              "#091233",
              "#43AC3A"
              ];

function makeChart(data, devs, number, active) {
  var activeClass = active !== true ? active = "" : "active";

  var tab = $("<li/>")
    .attr("class", activeClass);

  var tabLink = $("<a/>")
    .attr("role", "tab")
    .attr("data-toggle", "tab")
    .attr("href", "#" + number)
    .html("<em>t</em> = " + number)
    .click(function(e) {
      e.preventDefault();
      $("#" + number).tab("show");
      console.log($("#" + number));
    })
    .appendTo(tab);

  tab.appendTo($("#chartsTab"));

  var fullDiv = $("<div/>")
    .attr("class", "chartHolder tab-pane " + activeClass)
    .attr("id", number)

  $("<h3/>")
    .html("<em>t</em> = " + number)
    .appendTo(fullDiv);

  var div = $("<div/>")
    .appendTo(fullDiv);

  fullDiv.appendTo("#charts");

  var chord = d3.layout.chord()
    .padding(.05)
    .matrix(data);

  var w = 1000,
      h = 1000,
      r0 = Math.min(w, h) * .29,
      r1 = r0 * 1.1;

  var fill = d3.scale.ordinal()
      .domain(d3.range(4))
      .range(colors);

  var svg = d3.select(div[0])
    .append("svg:svg")
      .attr("width", w)
      .attr("height", h)
    .append("svg:g")
      .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

  var fadey = fade(.05);
  var unfadey = fade(0.8);

  svg.append("svg:g")
    .selectAll("path")
      .data(chord.groups)
    .enter().append("svg:path")
      .style("fill", function(d) { return fill(d.index); })
      .style("stroke", function(d) { return d3.rgb(fill(d.index)).darker(); })
      .attr("d", d3.svg.arc()
        .innerRadius(r0)
        .outerRadius(r1))
      .on("mouseover", fadey)
      .on("mouseout", unfadey);
    
  var ticks = svg.append("svg:g")
    .selectAll("g")
      .data(chord.groups)
    .enter().append("svg:g")
    .selectAll("g")
      .data(groupTicks)
    .enter().append("svg:g")
      .attr("transform", function(d) {
        return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
            + "translate(" + r1 + ",0)";
      });

  ticks.append("svg:line")
      .attr("x1", 1)
      .attr("y1", 0)
      .attr("x2", 5)
      .attr("y2", 0)
      .style("stroke", "#000");

  ticks.append("svg:a")
      .attr("class", "chordText")
      .attr("xlink:href", function(d) {
        return "https://github.com/" + d.label;
      })
      .append("svg:text")
        .attr("x", 8)
        .attr("dy", ".35em")
        .attr("font-size", "22px")
        .attr("text-anchor", function(d) {
          return d.angle > Math.PI ? "end" : null;
        })
        .attr("transform", function(d) {
          return d.angle > Math.PI ? "rotate(180)translate(-16)" : null;
        })
        .text(function(d) { return d.label; });

  svg.selectAll("a")
    .on("mouseover", fadey)
    .on("mouseout", unfadey);

  svg.append("svg:g")
      .attr("class", "chord")
    .selectAll("path")
      .data(chord.chords)
    .enter().append("svg:path")
      .style("fill", function(d) { return fill(d.target.index); })
      .style("stroke", function(d) { return d3.rgb(fill(d.target.index)).darker(); })
      .attr("d", d3.svg.chord().radius(r0))
      .style("opacity", 1);
      
  svg.selectAll("g.chord path")
    .on("mouseover", fadeNotOver(0.05))
    .on("mouseout", fadeNotOver(0.8));
  
  fade(0.8)();

  /** Returns an array of tick angles and labels, given a group. */
  function groupTicks(d) {
    var k = (d.endAngle - d.startAngle) / d.value;
    return d3.range(0, d.value, 1000).map(function(v, i) {
      return {
        angle: (d.startAngle + d.endAngle) / 2,
        label: devs[d.index]
      };
    });
  }


  /** Returns an event handler for fading a given chord group. */
  function fade(opacity) {
    return function(g, i) {
      svg.selectAll("g.chord path")
          .filter(function(d) {
            return d.source.index != i && d.target.index != i;
          })
        .transition()
          .style("opacity", opacity);
    };
  }

  function fadeNotOver(opacity) {
    return function(g, i) {
      //console.log("length: " + svg.selectAll("g.chord path").length);
      //console.log("i: " + i);
      //console.log(svg.selectAll("g.chord path")[0][i]);
      svg.selectAll("g.chord path")
        .filter(function(d, ind) {
          return i != ind;
        })
        .transition()
          .style("opacity", opacity);
    }
  }
}
