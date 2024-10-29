FROM python:3.10

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

RUN apt-get update -y && apt-get install -y --no-install-recommends build-essential gcc libsndfile1 ffmpeg espeak-ng git-lfs

RUN pip3 install torch torchvision torchaudio

# Install any needed packages specified in requirements.txt
RUN pip3 install -r requirements.txt --no-deps

RUN mkdir -p ckpt/speechtokenizer

RUN wget "https://huggingface.co/fnlp/SpeechTokenizer/resolve/main/speechtokenizer_hubert_avg/SpeechTokenizer.pt" && mv SpeechTokenizer.pt ckpt/speechtokenizer/SpeechTokenizer.pt

RUN wget "https://huggingface.co/fnlp/SpeechTokenizer/resolve/main/speechtokenizer_hubert_avg/config.json" && mv config.json ckpt/speechtokenizer/config.json

RUN wget "https://huggingface.co/fnlp/USLM/resolve/main/USLM_libritts/unique_text_tokens.k2symbols"  && mv unique_text_tokens.k2symbols ckpt/unique_text_tokens.k2symbols

RUN git clone https://huggingface.co/PolyAI/pheme ckpt/pheme

RUN mkdir -p "ckpt/t2s"

RUN mkdir -p "ckpt/s2a"

RUN mv ckpt/pheme/config_t2s.json ckpt/t2s/config.json

RUN mv ckpt/pheme/generation_config.json ckpt/t2s/generation_config.json

RUN mv ckpt/pheme/t2s.bin ckpt/t2s/pytorch_model.bin

RUN mv ckpt/pheme/config_s2a.json ckpt/s2a/config.json

RUN mv ckpt/pheme/s2a.ckpt ckpt/s2a/s2a.ckpt

RUN rm -rf ckpt/pheme

#RUN pip install torchvision

#RUN mkdir ~/.ssh
#RUN echo "Host *\
#        StrictHostKeyChecking accept-new\
#" > ~/.ssh/config
#RUN git lfs install && git lfs pull

CMD [ "python", "api.py" ]