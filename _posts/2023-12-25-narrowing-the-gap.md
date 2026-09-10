---
layout: post
title: "Narrowing the Gap: How can ML Pipelines Connect Development and Deployment"
date: 2023-12-11 04:00:00
description: ""
tags: ['MLOps', ]
---


# 1. Introduction
The team is divided, people face each other as if they are enemies, born to fight, poised for confrontation. As in the Ying Yang, they are faces of the same coin, destined to fight for their side, although the lack of balance would be catastrophic... The air is thick with anticipation as if a grand chessboard has been set, the players locked in a strategic standoff.
Sometimes this is how it feels to be in a team divided between Data Scientists and ML/Software Engineers, they have different objectives, sometimes conflicting, which puts the teams in a situation of tug war.


<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/face-off-of-two-factions.png" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Figure 1 - Two faction face off."
    %}
</div>

<style>
    /* For desktops and larger tablets */
    @media (min-width: 768px) {
        .img-fluid {
            width: 60%;
        }
    }

    /* For mobile phones and smaller devices */
    @media (max-width: 767px) {
        .img-fluid {
            width: 100%;
        }
    }
</style>

At the core of a Data Scientist's work is the pursuit of knowledge and insights derived from data. Their focus often lies in the realms of statistics, machine learning, and predictive modeling. Data Scientists seek to transform raw data into actionable insights, this incentivizes them to have a fast iteration speed so they can test multiple ideas and ship actionable insights fast. 

ML/Software Engineers, on the other hand, are primarily concerned with the implementation and operationalization of these data models. Their goal is to build scalable, efficient, and reliable software systems that can integrate machine learning models into practical applications. They focus on the engineering aspects such as system design, code optimization, and deployment strategies. Their work is rooted in ensuring that the theoretical models created by Data Scientists are translated into working solutions that can operate under real-world constraints and deliver real results.

The conflict between Data Scientists and ML/Software Engineers often arises from their differing priorities and approaches. Data Scientists may prioritize iteration speed, model complexity, and accuracy, which can lead to sophisticated models that are difficult to deploy and manage in a practical, real-world system. ML Engineers focused on maintainability, scalability, and performance, might favor simpler, extensible tested, more efficient models that are easier to maintain and integrate into existing systems. This divergence can lead to tensions, as the Data Scientists try to iterate fast on the theoretical best solutions and ML/Software Engineers focus on code maintainability and robustness. 

The result of this polarity/division is a big cycle time (the time needed for an idea to arrive in production). Two common reasons for this high cycle time are:
* Lack of tools/standards in development/iteration: results in too much copy-paste between notebooks that leads to poor reproducibility and difficulty for other scientists and engineers to identify changes;
* No common abstractions between development code and production code: data scientist codes get completely refactored before arriving in the Production environment;

This team split and the problems it raises are well-known in the (traditional software industry)[link-to-devops] and now have its flavor in the ML world: **MLOps**.

<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/mlops-entity.jpeg" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Figure 2 - Dall-E representation of prompt 'A powerful entity called “MLOps” ending a war between a group of data scientists and ml engineers, cyberpunk style'."
    %}
</div>

MLOps aims to unify scientists and engineers, eliminating the need for cumbersome handovers. A key abstraction that can bring everyone on the same page is the concept of "pipelines".

# 2. Pipelines

Why is the concept of pipelines so attractive? First, it provides a clear and structured way to transform data, making it easier to manage and maintain. With pipelines, each step in the data transformation process is defined as a separate component, allowing for easier testing and reuse of those components. This modularity also means that changes to one component do not necessarily affect other pipeline parts, reducing the risk of unexpected behavior. In Figure 3 you can view a simple ML pipeline example.

<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/simple_ml_pipeline.png" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Figure 3 - Simple ML train pipeline."
    %}
</div>
<p style="margin-bottom:0;">
    <details><summary>(click to expand) <strong>Diagram Mermaid.js source code </strong></summary>
{% highlight bash %}
graph LR
    A[Raw Data] --> B[Preprocessing]
    B --> C[Training]
    C --> D[Evaluation]
{% endhighlight %}
    </details> 
</p>

Additionally, a whole pipeline can be abstractly encapsulated in a single script, making it easy for data scientists to experiment with different ideas during development. The ability to iterate on ideas quickly is essential for data scientists, and pipelines provide a mechanism for doing so while maintaining consistency in the overall process.

Finally, pipelines allow for easy deployment on optimized hardware. Different steps in a pipeline may have different hardware requirements, such as the need for GPUs for the generation of embeddings or more network and memory for data gathering/merging tasks. By splitting the pipeline into separate components, each component can be deployed on the hardware that is best suited to its specific requirements, allowing for optimal performance and cost-effectiveness with reduced development time.

In summary, the use of pipelines can provide many benefits, including modularity, easier testing and reuse, the ability to iterate quickly during development, and optimized deployment on specific hardware. In a nutshell, using pipelines can help streamline the development and deployment process, resulting in more efficient and effective ML-based initiatives.

So, what are those “steps” on an ML pipeline? Basically “data transformers”, see Fig. 4.


<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/data_transformer.png" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Figure 4 - \"Data Transformers\", what a single step of an ML pipeline might be."
    %}
</div>
<p style="margin-bottom:0;">
    <details><summary>(click to expand) <strong>Diagram Mermaid.js source code</strong></summary>
{% highlight bash %}
graph LR
    A[Data] --> B[Data Transformer]
    B --> C[Changed data]
{% endhighlight %}
    </details> 
</p>

Note: In this article, "transformers", is used in its root meaning: an object that transforms something, and not deep learning architecture that uses self-attention.

The idea is that in the long run, new complex ML pipelines can be just parameterizing versions of previously developed steps like in Fig. 5 (for a graphical representation of a team when this day arrives, see Fig. 6).


<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/complex-ml-pipeline.png" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Figure 5 - Just some complex ML pipeline."
    %}
</div>
<p style="margin-bottom:0;">
    <details><summary>(click to expand) <strong>Diagram Mermaid.js source code</strong></summary>
{% highlight bash %}
graph LR
    A[Data Filtering/Aggregation] --> B[Preprocessing]
    H --> D[Evaluation]
    D --> E[Deployment]
    B --> F[Inference]
    B --> C[Training]
    C --> H[Model Validation]
    C --> I[Model Selection]
    I --> J[Hyperparameter Tuning]
    J --> H
    B --> K[Feature Engineering]
    K --> B
    L[Other Data Source] --> A
    Q[Dashboard] --> F
    S[API] --> F
    T[Data Lake] --> A
    U[Data Warehouse] --> A
{% endhighlight %}
    </details> 
</p>


<div style="text-align: center">
    {% include figure.html path="assets/img/posts/2023-12-25-narrowing-the-gap/team-crying.png" class="img-fluid rounded z-depth-1" zoomable="true"
    caption = "Fig. 6 - Dall-E graphical representation of a team when ML pipeline maturity arrives. Prompt: “An engineer hugging a scientist as both cry very emotionally after seeing a high-quality software product delivered in no time, very low resolution pixel art”."
    %}
</div>

In light of this, if a team has a contract for the `DataTransformers` (if you don't know how to start, go with (sklearn pipelines)[link-2-sklearn-pipelines]), they will be:
* Encouraging modularity, best practices, and code reusability;
* Streamlining development and better code maintainability;
* Simplifying team collaboration and accelerating pipeline deployment;
* Facilitating the integration of new data sources and feature engineering;

