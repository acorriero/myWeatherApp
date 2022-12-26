import streamlit as st
import plotly.express as px
from backend import get_data

st.title("Weather Forcast for the Next Days")
place = st.text_input("Place: ")
days = st.slider("Forcast Days", min_value=1, max_value=5,
                 help="Select the number of forcasted days")

option = st.selectbox("Select data to view",
                      ("Temerature", "Sky"))

st.subheader(f"{option} for the next {days} days in {place}")

data = get_data(place, days, option)

figure = px.line(x=d, y=t, labels={"x": "Date", "y": "Temerature (C)"})

st.plotly_chart(figure)
