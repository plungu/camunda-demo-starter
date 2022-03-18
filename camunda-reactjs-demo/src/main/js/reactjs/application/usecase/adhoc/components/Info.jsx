/**
 * @author Paul Lungu
 * @type {{DOM, PropTypes, createElement, isValidElement, version, __spread, PureComponent, createMixin, createClass, Children, Component, createFactory, cloneElement}}
 */

'use strict';

// tag::nodeModules[]
const React = require('react');

// tag::customComponents
// tag::vars[]


class Info extends React.Component{
  constructor(props) {
      super(props);
  }

  render() {
      var item  = null;
      var employeeAddress = `${this.props.user.street}  ${this.props.user.city}  ${this.props.user.state}  ${this.props.user.zip}  ${this.props.user.country}`;

      let email = this.props.item.email;
      if (this.props.formProps.email != null)
        email = this.props.formProps.email;

      let message = this.props.item.message;
      if (this.props.formProps.message != null)
          message = this.props.formProps.message;


      if (this.props.item  != null){
          item  =
              <div>
                  <div className="small-5 columns" >
                      <div className="card" >
                          <div className="card-divider text-center">
                              <h4>User Info</h4>
                          </div>
                          <div className="card-section" style={{borderTop: "1px dashed #2199e8"}}>
                              <ul>
                                  <li><span className="label">First Name</span>
                                      <span className="data">{this.props.user.first} </span></li>
                                  <li><span className="label">Last Name</span>
                                      <span className="data">{this.props.user.last} </span></li>
                                  <li><span className="label">Email</span>
                                      <span className="data">{this.props.user.email}</span></li>
                                  <li><span className="label">Phone</span>
                                      <span className="data">{this.props.user.phone}</span></li>
                                  <li><span className="label">Address</span>
                                      <span className="data">{employeeAddress}</span></li>
                              </ul>
                          </div>
                      </div>
                  </div>
                  <div className="small-6  columns">
                      <div className="card" >
                          <div className="card-divider text-center">
                              <h4>Case Info</h4>
                          </div>
                          <div className="card-section" style={{borderTop: "1px dashed #2199e8"}}>
                              <ul>
                                  <li><span className="label">Case Id</span>
                                      <span className="data">{this.props.item.key}</span></li>
                                  <li><span className="label">Status</span>
                                      <span className="data">{this.props.item.status}</span></li>
                                  <li><span className="label">Message</span>
                                      <span className="data">{message}</span></li>
                                  <li><span className="label">Email</span>
                                      <span className="data">{email}</span></li>
                              </ul>
                          </div>
                      </div>
                  </div>
              </div>
      }

      return (
          <div>
              <div className="columns" style={{borderBottom: "0px solid white", padding: "10px"}}></div>
              {item}
              <div className="columns" style={{borderBottom: "0px solid white", padding: "5px"}}></div>
          </div>
      )
  }
  
}
  
module.exports = Info;