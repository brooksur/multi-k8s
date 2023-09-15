import React, { Component } from "react";
import axios from "axios";

class Fib extends Component {
  state = {
    seenIndexes: [],
    values: {},
    index: "",
  };

  componentDidMount() {
    this.fetchValues();
    this.fetchIndexes();
  }

  async fetchValues() {
    const values = await axios.get("/api/values/current");
    this.setState({ values: values.data });
  }

  async fetchIndexes() {
    const seenIndexes = await axios.get("/api/values/all");
    this.setState({
      seenIndexes: seenIndexes.data,
    });
  }

  handleSubmit = async (event) => {
    event.preventDefault();

    await axios.post("/api/values", {
      index: this.state.index,
    });
    this.setState({ index: "" });
  };

  renderSeenIndexes() {
    const entries = [];

    for (let key in this.state.seenIndexes) {
      entries.push(<li key={key}>key</li>);
    }

    return entries;
  }

  renderValues() {
    const entries = [];

    for (let key in this.state.values) {
      entries.push(
        <li key={key}>
          For index {key} I calculated {this.state.values[key]}
        </li>
      );
    }

    return entries;
  }

  render() {
    return (
      <div>
        <form onSubmit={this.handleSubmit}>
          <label>Enter your index:</label>
          <input
            value={this.state.index}
            onChange={(event) => this.setState({ index: event.target.value })}
          />
          <button>Calculate</button>
        </form>

        <h3>Indexes I have seen</h3>
        <ul>{this.renderSeenIndexes()}</ul>

        <h3>Calculated Values</h3>
        <ul>{this.renderValues()}</ul>
      </div>
    );
  }
}

export default Fib;
