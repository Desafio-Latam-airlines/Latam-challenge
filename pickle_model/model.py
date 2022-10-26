import pickle
import boto3

s3 = boto3.resource('s3')
my_model = pickle.loads(s3.Bucket("bucket_name").Object("key_to_pickle.pickle").get()['Body'].read())